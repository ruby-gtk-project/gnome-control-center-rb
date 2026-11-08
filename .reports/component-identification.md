# Component identification — gnome-control-center-rb

Upstream: `origin/main` @ `a53c22ada`. Port: `ruby` @ `b0f61703e`.

## Scope of this pass

Per the `component-identification` skill, identification is scoped unit by
unit. This pass re-audits the shell (`window.rb`, `panel_list.rb`,
`panel_loader.rb`, `panel.rb`, `shell_model.rb`, `application.rb`,
`log.rb`, `object_storage.rb`), one panel (`about_panel.rb`), and the two
shared-utility/enum units (`panels/common/*`, the sharing/sound enum
files) that landed since the previous pass (commit `f8acc1220`). It relies
on the opening survey (`.reports/component-inventory.md`, 278 upstream
component files across 24 panels) for everything else, which remains at 0
files ported, with the two exceptions (sharing, sound) that now have one
enum file each but still no panel.

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

## Unit: `shell/cc-log.c/.h` → `log.rb`, `shell/cc-object-storage.c/.h` → `object_storage.rb` (new this pass)

Both exist and are called from `Application#build` (`Log.init`,
`ObjectStorage.initialize_storage`) — confirmed by reading
`lib/gnome_control_center/application.rb:24-25` and by
`test/drive_shell.rb`'s two new checks (`ObjectStorage` marks itself
initialized; a second `initialize_storage` call refuses, matching
upstream's singleton guard).

`log.rb`'s own class comment states a real binding limitation, not an
excuse: upstream installs itself as GLib's structured-log writer
(`g_log_set_writer_func`) so it filters/colorizes every `g_log`/`g_debug`
call anywhere in the C process, including inside GTK itself; ruby-gnome's
GI bindings expose no equivalent hook, so the port's `Log` can only
format and filter messages that Ruby code explicitly routes through it.
That is accurate (verified: no `GLib.log_set_writer_func` or similar
exists in the `gi`/`gio2` gems loaded by this devshell) and is recorded
as a binding limitation, not "out of scope" — contrast with the
`window.rb` finding above and in `accountability-ensurance.md`.

**Gap found reading both files against their actual callers:** neither
`Log` nor `ObjectStorage` has a second caller anywhere in `lib/` besides
the one boot call in `application.rb`. `Log.init` is called but nothing
in the port ever calls `Log.debug`/`Log.warning`/etc. for an actual event
— confirmed, `grep -rn "Log\."` outside `log.rb` and `application.rb`
turns up only the one `Log.init` line. `ObjectStorage.initialize_storage`
is called but nothing ever stores or fetches a proxy through it —
`grep -rn "ObjectStorage\."` outside its own file and `application.rb`
turns up only the two `test/drive_shell.rb` assertions, which check the
singleton guard, not an actual cached proxy. Both modules are real,
correctly structured code that is currently **wired but inert**: it runs
once at boot and is never exercised for the purpose it exists for (a
panel storing/looking up a shared D-Bus proxy; a panel logging a real
event), because no panel that would call either one exists yet.

## Unit: `panels/common/cc-util.c/.h` → `util.rb`, `cc-ui-util.c/.h` → `ui_util.rb` (new this pass)

`util.rb`'s `normalize_casefold_and_unaccent` is called from
`shell_model.rb:111` for search matching — confirmed, has a real caller,
exercised indirectly by `test/drive_shell.rb`'s search checks.

**Gap found reading `ui_util.rb` against its callers:** `grep -rn
"Common::UiUtil"` across `lib/`, `exe/`, `test/`, `spec/` finds the
module's own definition and nothing else. `ui_util.rb` (upstream's
`cc_util_keynav_propagate_vertical`/`_horizontal`, for bouncing focus at a
listbox edge up to the window) is ported faithfully but has **zero
callers** anywhere in the port. No widget in `window.rb` or
`panel_list.rb` installs it on a key-press-event the way upstream's
panels do. It is dead code today — correct in isolation, unverifiable in
practice because nothing invokes it.

## Unit: `panels/sharing/gsd-sharing-enums.h` → `gsd_sharing_enums.rb`, `panels/sound/cc-sound-enums.h` → `sound_enums.rb` (new this pass)

Both are faithful enum ports (`SharingStatus`, `StreamType`) but, per the
same check, have **zero callers** outside their own defining file —
confirmed, `grep -rln "SharingStatus"` and `grep -rln "StreamType"` across
`lib/`, `exe/`, `test/`, `spec/` return only `gsd_sharing_enums.rb` and
`sound_enums.rb` themselves. Neither the sharing panel nor the sound
panel exists yet to consume them, so these two files are, like `ui_util.rb`
above, correctly-shaped code with no behaviour attached to it yet.

## Everything else

23 panels (22 excluding `sharing`/`sound`, which now have one enum file
each but no panel), 278 distinct non-shell upstream component files per
the original survey (`.reports/component-inventory.md`). `applications`,
`background`, `bluetooth`, `color`, `display`, `keyboard`, `mouse`,
`multitasking`, `network`, `notifications`, `online-accounts`, `power`,
`printers`, `privacy`, `search`, `system` (minus the `about` sub-page
above), `universal-access`, `wacom`, `wellbeing`, `wwan`: **zero files
exist in `lib/` for any of them**, and `sharing`/`sound` have only an enum
file each, no panel. `search-provider/` and `global-shortcuts-provider/`
(the two D-Bus services): zero. No `.blp`/`.ui` equivalent exists on the
port side by house style, confirmed — `find lib -iname '*.ui' -o -iname
'*.blp'` is empty, as expected.

## Totals

| | Upstream | Port |
|---|---:|---:|
| Panels with any file | 24 | 1 (about, partial) + 2 (sharing/sound, enum-only) + shell |
| Component files (non-shell) | 278 | 5 (about_panel, util, ui_util, 2 enums — 2 of the 5 with no caller) |
| Shell files | 15 | 9 (missing only `shortcuts_dialog.rb`; `log.rb`/`object_storage.rb` now exist, boot-wired but inert — see above) |
| D-Bus service units (search-provider, global-shortcuts-provider) | 2 | 0 |
