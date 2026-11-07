# frozen_string_literal: true

require "gtk4"
require "adwaita"
require_relative "shell_model"

module GnomeControlCenter
  # PanelList is the shell's sidebar: a scrollable, categorized list of every
  # visible panel, and a second list — crossfaded in over the first — that
  # shows only the panels matching the current search.
  #
  # Ported from upstream's shell/cc-panel-list.c/.h, an AdwBin wrapping a
  # GtkStack of two GtkListBoxes built from a GtkBuilder template
  # (cc-panel-list.ui). This port has no template, so both listboxes are
  # built in Ruby; it also drops upstream's `panel_order` — a hand-maintained
  # array naming all ~40 real panel ids, used only to know where to draw a
  # separator — in favour of comparing each row's category to the row before
  # it, which gives the same "a line between groups" result from the
  # category each panel already carries without a second list to keep in
  # sync with the model.
  class PanelList < Adwaita::Bin
    def initialize(model, on_show_panel:)
      super()
      @model = model
      @on_show_panel = on_show_panel
      @view = :main
      @previous_view = :main
      @search_words = []
      @row_ids = {}
      @id_rows = {}
      @search_row_ids = {}
      @search_id_rows = {}
      self.child = stack
    end

    def build
      tap do
        stack.tap do |s|
          s.add_named(main_scroller, "main")
          s.add_named(search_scroller, "search")
        end

        main_listbox.tap do |lb|
          lb.set_sort_func { |a, b| compare_rows(a, b) }
          lb.set_header_func { |row, before| set_row_header(row, before) }
          lb.signal_connect("row-activated") { |_, row| activate_main_row(row) }
        end

        search_listbox.tap do |lb|
          lb.set_filter_func { |row| row_matches_search?(row) }
          lb.set_sort_func { |a, b| compare_search_rows(a, b) }
          lb.signal_connect("row-activated") { |_, row| activate_search_row(row) }
        end
      end
      refresh
      self
    end

    # Upstream's cc_panel_list_get_search_query / set_search_query.
    attr_reader :search_query

    def search_query=(query)
      @search_query = query
      @search_words = query.to_s.split.map { |word| ShellModel.normalize_casefold_and_unaccent(word) }
      @model.sort_terms = @search_words
      update_search_view
      search_listbox.invalidate_filter
      search_listbox.unselect_all
    end

    # Upstream's cc_panel_list_get_view.
    attr_reader :view

    # Upstream's cc_panel_list_get_current_panel.
    attr_reader :current_panel_id

    # Upstream's cc_panel_list_set_active_panel: selects the row for `id` in
    # whichever list is currently showing it, without re-emitting show-panel.
    def active_panel_id=(id)
      @current_panel_id = id
      @id_rows[id]&.then { |row| main_listbox.select_row(row) }
    end

    # Upstream's cc_panel_list_add_panel, except visibility lives on the
    # model (set beforehand via ShellModel#add_item) rather than being
    # passed again here.
    def refresh
      main_listbox.tap do |lb|
        @id_rows.each_value { |row| lb.remove(row) }
      end
      search_listbox.tap do |lb|
        @search_id_rows.each_value { |row| lb.remove(row) }
      end
      @row_ids.clear
      @id_rows.clear
      @search_row_ids.clear
      @search_id_rows.clear

      @model.entries.each do |entry|
        unless entry.visibility == ShellModel::HIDDEN
          main_listbox.append(build_row(entry).tap { |row| register_row([@row_ids, @id_rows], row, entry.id) })
          search_listbox.append(build_row(entry).tap { |row| register_row([@search_row_ids, @search_id_rows], row, entry.id) })
        end
      end

      main_listbox.invalidate_sort
      search_listbox.invalidate_sort
      search_listbox.invalidate_filter
    end

    def main_scroller = @main_scroller ||= Gtk::ScrolledWindow.new.tap { |sw| sw.child = main_listbox }
    def search_scroller = @search_scroller ||= Gtk::ScrolledWindow.new.tap { |sw| sw.child = search_listbox }
    def stack = @stack ||= Gtk::Stack.new.tap { |s| s.transition_type = :slide_left_right }
    def main_listbox = @main_listbox ||= Gtk::ListBox.new.tap { |lb| lb.add_css_class("navigation-sidebar") }
    def search_listbox = @search_listbox ||= Gtk::ListBox.new.tap { |lb| lb.add_css_class("navigation-sidebar") }

    private

      def build_row(entry)
        Gtk::ListBoxRow.new.tap do |row|
          row.child = row_box(entry)
        end
      end

      def row_box(entry)
        Gtk::Box.new(:horizontal, 12).tap do |box|
          box.margin_top = 12
          box.margin_bottom = 12
          box.margin_start = 6
          box.margin_end = 6

          box.append(Gtk::Image.new(icon_name: entry.icon))
          box.append(row_label(entry))
        end
      end

      def row_label(entry)
        Gtk::Label.new(entry.name).tap do |label|
          label.xalign = 0.0
          label.hexpand = true
        end
      end

      def register_row(hashes, row, id)
        id_hash, row_hash = hashes
        id_hash[row] = id
        row_hash[id] = row
      end

      def row_entry(id_hash, row) = @model.entry_for(id_hash[row])

      def compare_rows(row_a, row_b)
        a = row_entry(@row_ids, row_a)
        b = row_entry(@row_ids, row_b)
        by_category = category_order(a.category) <=> category_order(b.category)
        by_category.zero? ? a.casefolded_name <=> b.casefolded_name : by_category
      end

      def compare_search_rows(row_a, row_b)
        entries = @model.entries
        entries.index(row_entry(@search_row_ids, row_a)) <=> entries.index(row_entry(@search_row_ids, row_b))
      end

      def row_matches_search?(row)
        entry = row_entry(@search_row_ids, row)
        visible = !entry.nil? && entry.visibility != ShellModel::HIDDEN
        visible && (@search_words.empty? || @search_words.any? { |word| ShellModel.matches_search?(entry, word) })
      end

      def set_row_header(row, before)
        if before.nil?
          row.set_header(nil)
        else
          current = row_entry(@row_ids, row)
          previous = row_entry(@row_ids, before)
          row.set_header(current.category == previous.category ? nil : Gtk::Separator.new(:horizontal))
        end
      end

      def category_order(category) = ShellModel::CATEGORIES.index(category) || ShellModel::CATEGORIES.size

      def activate_main_row(row)
        @view = :main
        id = @row_ids[row]
        @current_panel_id = id
        @on_show_panel.call(id)
      end

      def activate_search_row(row)
        id = @search_row_ids[row]
        @current_panel_id = id
        @view = :main
        main_listbox.select_row(@id_rows[id])
        @on_show_panel.call(id)
      end

      # Upstream's update_search: only an active query switches the stack to
      # the search view; clearing it returns to whichever view preceded it.
      def update_search_view
        if @search_query.to_s.empty?
          @view = @previous_view
        else
          if @view != :search
            @previous_view = @view
          end
          @view = :search
        end

        if @view == :search
          stack.visible_child_name = "search"
        else
          stack.visible_child_name = "main"
        end
      end
  end
end
