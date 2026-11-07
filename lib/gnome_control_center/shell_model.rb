# frozen_string_literal: true

require_relative "../panels/common/util"

module GnomeControlCenter
  # ShellModel lists every panel the shell knows about — its category, id,
  # display metadata and search visibility — and knows how to sort and
  # filter that list for the sidebar and the search view.
  #
  # Ported from upstream's shell/cc-shell-model.c, a GtkListStore subclass
  # with a fixed column layout and a GtkTreeSortable sort function keyed on
  # search terms. This port drops GtkListStore/GtkTreeModel entirely — there
  # is no GtkTreeView consumer in a GTK4 port — and keeps only the upstream
  # behaviour: items, categories, visibility, name/description/keyword
  # normalization (upstream's cc_util_normalize_casefold_and_unaccent), and
  # the two sort orders (plain alphabetical, and "best match for these
  # search terms").
  class ShellModel
    # Mirrors upstream's CcPanelCategory enum order (CC_CATEGORY_LAST is not
    # a real category and has no counterpart here).
    CATEGORIES = %i[connectivity personalization account hardware devices details system privacy].freeze

    # Mirrors upstream's CcPanelVisibility enum.
    HIDDEN = :hidden
    VISIBLE_IN_SEARCH = :visible_in_search
    VISIBLE = :visible

    Entry = Struct.new(
      :category,
      :id,
      :name,
      :description,
      :icon,
      :keywords,
      :visibility,
      :casefolded_name,
      :casefolded_description,
      :casefolded_keywords,
      keyword_init: true,
    )

    def initialize
      @entries = []
      @sort_terms = []
    end

    # Upstream's cc_shell_model_add_item. New items start CC_PANEL_VISIBLE,
    # matching upstream's gtk_list_store_insert_with_values call.
    def add_item(category, id:, name:, description: nil, icon: nil, keywords: [])
      if has_panel?(id)
        raise ArgumentError, "panel already registered: #{id}"
      end

      @entries << Entry.new(
        category:               category,
        id:                     id,
        name:                   name,
        description:            description,
        icon:                   icon,
        keywords:               Array(keywords),
        visibility:             VISIBLE,
        casefolded_name:        self.class.normalize_casefold_and_unaccent(name),
        casefolded_description: self.class.normalize_casefold_and_unaccent(description),
        casefolded_keywords:    Array(keywords).map { |word| self.class.normalize_casefold_and_unaccent(word) },
      )
    end

    # Upstream's cc_shell_model_has_panel.
    def has_panel?(id) = @entries.any? { |entry| entry.id == id }

    def entry_for(id) = @entries.find { |entry| entry.id == id }

    # Upstream's cc_shell_model_set_panel_visibility.
    def set_panel_visibility(id, visibility)
      entry = entry_for(id)
      unless entry
        raise ArgumentError, "no such panel: #{id}"
      end

      entry.visibility = visibility
    end

    # Upstream's cc_shell_model_set_sort_terms.
    def sort_terms=(terms)
      @sort_terms = Array(terms).map { |term| self.class.normalize_casefold_and_unaccent(term) }.reject(&:empty?)
    end

    attr_reader :sort_terms

    # Entries in the shell's current sort order — plain alphabetical with no
    # active search, or "best match for these terms" while searching.
    # Upstream's cc_shell_model_sort_func / sort_with_terms.
    def entries
      @sort_terms.empty? ? @entries.sort_by(&:casefolded_name) : @entries.sort { |a, b| compare_with_terms(a, b) }
    end

    # Upstream's cc_shell_model_iter_matches_search: the name, the
    # description, or a keyword that *starts with* the term (upstream uses
    # strstr for the first two, and ==keywords[j] for the keyword case,
    # i.e. the match has to begin at the keyword's first character).
    def self.matches_search?(entry, term)
      entry.casefolded_name.include?(term) ||
        !!entry.casefolded_description&.include?(term) ||
        Array(entry.casefolded_keywords).any? { |keyword| keyword.start_with?(term) }
    end

    # Upstream's cc_util_normalize_casefold_and_unaccent: NFKD-normalize,
    # casefold, then drop combining diacritical marks and the soft hyphen so
    # accented search terms match their unaccented panel names.
    def self.normalize_casefold_and_unaccent(str)
      Panels::Common::Util.normalize_casefold_and_unaccent(str)
    end

    private

      def compare_with_terms(a, b)
        [
          compare_name_with_terms(a, b),
          compare_keyword_matches(a, b),
          compare_description_matches(a, b)
        ].find { |result| !result.zero? } || (a.casefolded_name <=> b.casefolded_name)
      end

      # Upstream's sort_by_name_with_terms: the first term that distinguishes
      # the two names wins, regardless of how many terms follow.
      def compare_name_with_terms(a, b)
        distinguishing_term = @sort_terms.find do |term|
          a.casefolded_name.include?(term) != b.casefolded_name.include?(term)
        end

        if distinguishing_term.nil?
          0
        elsif a.casefolded_name.include?(distinguishing_term)
          -1
        else
          1
        end
      end

      # Upstream's sort_by_keywords_with_terms: more keyword hits sorts first.
      def compare_keyword_matches(a, b)
        count_term_matches(b.casefolded_keywords) <=> count_term_matches(a.casefolded_keywords)
      end

      # Upstream's sort_by_description_with_terms: a description beats no
      # description, then more word hits sorts first.
      def compare_description_matches(a, b)
        if a.casefolded_description && !b.casefolded_description
          -1
        elsif !a.casefolded_description && b.casefolded_description
          1
        elsif !a.casefolded_description && !b.casefolded_description
          0
        else
          count_term_matches(b.casefolded_description.split(" ")) <=> count_term_matches(a.casefolded_description.split(" "))
        end
      end

      def count_term_matches(words)
        @sort_terms.sum { |term| Array(words).count { |word| word.include?(term) } }
      end
  end
end
