# Component parity — gnome-control-center-rb

| | |
|---|---|
| Upstream | `main` @ `a53c22ada` |
| Port | `ruby` @ `b0f61703e` |
| Units with parity | 0 / 25 (24 panels + shell) |

Parity is judged per unit, four axes each (count, style, behaviour, text —
see the skill). No unit below reaches "parity" on all four.

## Unit: shell (window, panel list, panel loader)

| Widget | Up × | Port × | CSS | Signals | Text | Verdict |
|---|---:|---:|---|---|:-:|---|
| `Adw.ApplicationWindow` | 1 | 1 | — | — | — | parity |
| `Adw.NavigationSplitView` | 1 | 1 | — | — | — | parity |
| `Gtk.SearchBar`/`SearchEntry`/toggle | 1 each | 1 each | — | ✓ driven | — | parity |
| Category headers in `CcPanelList` | present (per `CcPanelCategory`) | 0 | — | — | — | **gap**: `panel_list.rb` has no header widget at all; invisible with 1 panel, real once a 2nd panel lands |
| `Gtk.ShortcutsWindow` (`shortcuts-dialog.blp`) + `win.show-help-overview` | 1 | 0 | — | ✗ | ✗ | **gap**: not built, action not installed |
| `activate_panel` parameters (deep link) | full `GVariant` params | `subpage_tag` only | — | — | — | **gap**, excused in a code comment — see accountability report |

Driven: 26/26 checks in `test/drive_shell.rb` pass (confirmed by running it
under `nix develop --command xvfb-run -a ruby test/drive_shell.rb` — "26 of
26 checks passed / DRIVE OK", re-run this session). The checks cover window
title, panel activation, about-panel data (including the disk-capacity row's
real UDisks call), `Log`/`ObjectStorage` boot wiring, search
toggle/filter/empty-state/row activation, sidebar activation, and
panel-registration count. They do not touch the shortcuts window, deep-link
parameters, or category headers, because none of those exist to check —
this is the "narrow drive run" the task calls out: 8 shell/about/support
surfaces driven, 0 of the 24-panel surface.

**Verdict: gap.** Shell has the skeleton wired but not the help/shortcuts
surface, not category grouping, and drops a documented upstream parameter.

## Unit: `log.rb` / `object_storage.rb` (new this pass)

| Behaviour | Up | Port | Verdict |
|---|---|---|---|
| Domain/verbosity-filtered colorized log output, callable from Ruby | yes | yes | parity (as far as callable-from-Ruby goes) |
| Intercepts GLib's own internal `g_log`/`g_debug` calls | yes (`g_log_set_writer_func`) | no — no such hook exists in ruby-gnome's GI bindings (verified) | **gap**, correctly documented as a binding limitation in `log.rb`'s own comment, not an excuse |
| Any call site in the port actually logs a real event through `Log` | n/a (every upstream file does) | **no** — `Log.init` is the only call anywhere outside `log.rb` itself | **gap**: wired but inert |
| Process-wide cached-proxy store, used by panels to share a D-Bus proxy | yes, used throughout upstream panels | `ObjectStorage.initialize_storage` called once at boot; no panel stores or fetches anything through it | **gap**: wired but inert, same pattern as `Log` |

**Verdict: gap.** Both modules are structurally faithful ports of their
upstream counterparts and are exercised by `drive_shell.rb`'s singleton-guard
checks, but neither is used for its actual purpose anywhere in the port yet,
because the panels that would use them (to log a real event, to cache a
real NetworkManager/hostname/ModemManager proxy) do not exist. Counting
these two files as "shell parity" without this caveat would be exactly the
false-green pattern `accountability-ensurance.md` warns about: a file
existing and being called once at boot is not the same as the behaviour it
exists to provide being present.

## Unit: `panels/common/util.rb` / `ui_util.rb`, sharing/sound enums (new this pass)

| File | Has a real caller? | Verdict |
|---|---|---|
| `util.rb` (`normalize_casefold_and_unaccent`) | yes — `shell_model.rb:111`, exercised by search | parity for the one function ported |
| `ui_util.rb` (keynav propagation) | **no** — zero callers anywhere in `lib/`/`exe/`/`test/`/`spec/` | **gap**: dead code, unverifiable because nothing invokes it |
| `gsd_sharing_enums.rb` (`SharingStatus`) | **no** — zero callers outside its own file | **gap**: dead code, no sharing panel exists to use it |
| `sound_enums.rb` (`StreamType`) | **no** — zero callers outside its own file | **gap**: dead code, no sound panel exists to use it |

**Verdict: gap.** 1 of these 4 files does real work today; the other 3 are
correctly-shaped but currently inert, ported ahead of the panel that would
give them a caller.

## Unit: about panel

| Widget | Up × (from `cc-about-page.blp`) | Port × | CSS | Signals | Text | Verdict |
|---|---:|---:|---|---|:-:|---|
| Processor/memory/OS/kernel rows | 4 | 4 | — | — | ✗ (see translation report) | **gap** on text axis — none of the 4 row titles go through `_()`/`gettext`; byte-identical-but-unmarked is still a gap per the skill |
| Hardware model row | 1 | 0 | — | — | — | **gap** |
| Graphics row | 1 | 0 | — | — | — | **gap** |
| Disk capacity row | 1 | 0 | — | — | — | **gap** |
| Hostname "Rename…" entry row + rename dialog | 1 | 0 | — | — | — | **gap** |
| "Copy to clipboard" action row (`win.about.copy-info`) | 1 | 0 | — | ✗ | — | **gap** |
| Software Updates / Support / Send Feedback rows | 3 | 0 | — | — | — | **gap** |

**Verdict: gap.** 4 of roughly 11 upstream rows exist; the 4 that exist are
unmarked for translation.

## Units: the remaining 23 panels

`applications`, `background`, `bluetooth`, `color`, `display`, `keyboard`,
`mouse`, `multitasking`, `network`, `notifications`, `online-accounts`,
`power`, `printers`, `privacy`, `search`, `sharing`, `sound`,
`system` (minus `about`), `universal-access`, `wacom`, `wellbeing`, `wwan`,
plus the `search-provider` and `global-shortcuts-provider` D-Bus services.

No file exists on the port side for any of them (confirmed:
`find lib -type f` lists 10 files total, all shell/about/skeleton — see
`.reports/component-identification.md`). Every widget, CSS class, signal,
action and string any of these 278 component files builds is a gap by the
count axis alone; style/behaviour/text do not apply because there is nothing
to check them against. This is not 23 small gaps — `cc-network-panel.blp` +
`net-device-wifi.c`/`net-device-ethernet.c`/`net-device-mobile.c` +
`connection-editor/*` alone is dozens of rows, dialogs and a whole NM
connection-editing flow; `system/users` is the add-user, password, and
fingerprint-enrolment dialogs; `printers` is the entire CUPS discovery and
job-management UI. Listing each is the inventory's job
(`.reports/component-inventory.md`); this report's job is to say plainly
that **zero of the 23 have been started** (two more, `sharing` and
`sound`, now have one inert enum file each but still no panel), so a count
like "8 components verified by the drive gate" cannot be read as "8 of the
app's components." 8 is 8 of this one panel-and-shell slice; the app has
24 panels.

## Rules check

- No unit-wide claim of parity is made anywhere in this report, and none
  should be made elsewhere in the repo: 0/25.
- The one place an "extra" appears (the port's flat panel-list vs upstream's
  categorized one) is recorded as a gap, not waved through, because it is a
  behavioural simplification, not a renamed correspondence.
