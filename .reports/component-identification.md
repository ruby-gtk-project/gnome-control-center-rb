# Component identification — gnome-control-center-rb

Upstream: `origin/main` @ `a53c22ada`. Port: `ruby` @ `f8acc1220`.

## Scope of this pass

Per the `component-identification` skill, identification is scoped unit by
unit. The port currently has exactly two units built: the shell
(`window.rb`, `panel_list.rb`, `panel_loader.rb`, `panel.rb`,
`shell_model.rb`, `application.rb`) and one panel (`about_panel.rb`). This
report identifies components for those two units in full, and relies on the
prior opening survey (`.reports/component-inventory.md`, 278 upstream
component files across 24 panels, 0 ported at the time it was written) for
everything else, which is now 23 panels still at 0.

## Unit: shell — `shell/cc-window.blp` + `cc-window.c/.h` → `lib/gnome_control_center/window.rb`

Upstream `cc-window.blp` template root is `Adw.ApplicationWindow`, containing
a header bar, a search button/entry/bar, and an `Adw.NavigationSplitView`
wrapping a `CcPanelList` sidebar and content pane.

| Widget | × (port) | CSS | Signals | Notes |
|---|---:|---|---|---|
| `Adw.ApplicationWindow` | 1 | — | — | `window.rb` |
| `Adw.NavigationSplitView` (`split_view`) | 1 | — | — | sidebar/content |
| `Gtk.SearchBar` (`search_bar`) | 1 | — | — | `search_mode_enabled` toggled |
| `Gtk.SearchEntry` (`search_entry`) | 1 | — | `notify::text`(via `changed`?) | drives panel-list filtering |
| `Gtk.ToggleButton` (`search_button`) | 1 | — | `toggled` | opens `search_bar` |
| `Adwaita::NavigationView` (`navigation_view`) | 1 | — | — | hosts per-panel subpages |

Behaviour identified and driven by `test/drive_shell.rb`: panel activation,
search mode toggle, search filtering, empty-search state, search-row
activation returning to main view, sidebar row activation.

**Gap found while reading `activate_panel`/`navigation_view` (not caught by
any drive check):** upstream's `cc_window_set_active_panel_from_id` accepts a
`GVariant *parameters` used for deep-linking into a panel's subpage (the
search provider, `--panel` CLI launches, and D-Bus activation with
parameters all route through this). The port's `activate_panel` takes a
single `subpage_tag:` keyword and the surrounding comment in
`lib/gnome_control_center/window.rb:79-81` says the rest of upstream's
parameters are "out of scope for this port, since nothing yet activates the
shell with one." That is not a scoping decision available to the port —
see `.reports/accountability-ensurance.md` for the citation and why this
line is itself a finding, not a mitigant.

Upstream also defines a standalone `shell/shortcuts-dialog.blp`
(`Gtk.ShortcutsWindow`, triggered by the `win.show-help-overview` action and
the usual `<Control>question`/`F1` accelerators). **Not ported, not
mentioned anywhere in the port.** `lib/gnome_control_center/application.rb`
installs no `show-help-overview` action.

## Unit: shell — `cc-panel-list.blp/.c/.h` → `panel_list.rb`

Upstream's panel list renders category headers (per `CcPanelCategory`) above
each panel's row, with the `used-panel`/`row` CSS classes and keynav. The
port's `panel_list.rb` (216 lines) builds a flat `main_listbox` +
`search_listbox` pair — confirmed by reading the file: there is no
category-header widget, so the sidebar for a real multi-panel app (which the
port does not yet have) would render all panels in one flat list instead of
grouped under "Network", "Hardware", "Personal", "System" headers the way
upstream does. This is invisible today only because the port has one panel
and one category; it is a real gap waiting in the one file that will need to
carry 24 panels.

## Unit: `cc-about-page.blp/.c/.h` (panels/system/about/) → `about_panel.rb`

This is the file the inventory survey mapped to
`lib/panels/system/about_cc_about_page.rb`; the port instead ships it as
`lib/gnome_control_center/panels/about_panel.rb`, a rename/relocation, which
is a correspondence per the skill (not a gap by itself — the mapping is
recorded here so a future reviewer does not look for the inventory's literal
path and report it missing).

Rows actually ported (read from the file and driven by
`test/drive_shell.rb`'s "about panel shows real data" step): processor,
memory, OS name, kernel `Adw.ActionRow`s sourced from
`lib/gnome_control_center/system_info.rb`.

Upstream's `cc-about-page.blp` additionally has (not found anywhere in
`about_panel.rb`, confirmed by reading the whole 99-line file):

- Hardware model row, graphics row, disk-capacity row, "Rename…"
  (hostname) entry row with its own `Edit` dialog.
- The `Adw.StatusPage`/logo + "Software Updates"/"Support"/"Send Feedback"
  action rows, and their external-link/portal launches.
- The "Copy to clipboard" (`win.about.copy-info`) action and the Avahi/
  hostname-edit flow.

Given upstream's file holds roughly a dozen rows and the port has 4, this
unit is itself partial, not just "the easy one plus everything else is
missing."

## Everything else

24 panels, 278 distinct non-shell upstream component files per the original
survey (`.reports/component-inventory.md`). `applications`, `background`,
`bluetooth`, `color`, `display`, `keyboard`, `mouse`, `multitasking`,
`network`, `notifications`, `online-accounts`, `power`, `printers`,
`privacy`, `search`, `sharing`, `sound`, `system` (minus the `about` sub-page
above), `universal-access`, `wacom`, `wellbeing`, `wwan`: **zero files exist
in `lib/` for any of them.** `search-provider/` and
`global-shortcuts-provider/` (the two D-Bus services): zero. No `.blp`/`.ui`
equivalent exists on the port side by house style, confirmed — `find lib -iname '*.ui' -o -iname '*.blp'` is empty, as expected.

## Totals

| | Upstream | Port |
|---|---:|---:|
| Panels with any file | 24 | 1 (about, partial) + shell |
| Component files (non-shell) | 278 | ~1 (about_panel.rb) |
| Shell files | 15 | 7 (missing `object_storage.rb`, `log.rb`, `shortcuts_dialog.rb`) |
| D-Bus service units (search-provider, global-shortcuts-provider) | 2 | 0 |
