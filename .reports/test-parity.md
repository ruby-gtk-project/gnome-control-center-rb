# Test parity — gnome-control-center-rb

| | |
|---|---|
| Upstream | `main` @ `a53c22ada` |
| Port | `ruby` @ `b0f61703e` |
| Upstream tests (censused, `tests/`) | ≥ 15 test binaries/scripts, many data-driven (see below) |
| Ported | 0 |
| Gaps | all |
| Test command found | `rspec spec` (28 examples, plain RSpec — the gemspec declares `kettle-test`/`kettle-dev` as dev dependencies but they are not present in this nix devshell, so `spec_helper.rb` falls back and warns "kettle-test isn't installed; running with plain RSpec"), and a separate headless driver `test/drive_shell.rb` run with `nix develop --command xvfb-run -a ruby test/drive_shell.rb` (26 of 26 checks) |

## Upstream census (`git ls-tree -r --name-only origin/main | grep '^tests/'`)

Upstream ships a real, non-trivial `tests/` tree:

- `tests/common/test-hostname.c`, `test-time-entry.c` (+ data files
  `hostnames-test.txt`, `ssids-test.txt`)
- `tests/datetime/test-datetime.py`, `test-endianess.c`,
  `test-timezone-gfx.c`, `test-timezone.c`
- `tests/keyboard/test-keyboard-shortcuts.c`, `test-keyboard.py`
- `tests/network/test-network-panel.c`, `test-network-panel.py`,
  `test-wifi-text.c`, plus a vendored `nm-utils/` test harness and a fake
  NetworkManager D-Bus service (`test-networkmanager-service.py`) used to
  drive the network panel without real hardware
- `tests/printers/test-canonicalization.c`, `test-shift.c` (+ data files
  `canonicalization-test.txt`, `shift-test.txt`)
- `tests/interactive-panels/` — a whole second test harness app
  (`gtp-dynamic-panel`, `gtp-static-init`) for exercising panel
  loading/lifecycle
- `tests/shared/gtest.py`, `x11session.py` — shared test infrastructure

Each `.c` file registers multiple `g_test_add_func`/data-driven cases (the
canonicalization and shift tests are explicitly table-driven off the
`.txt` fixture files; the datetime/timezone tests cover multiple zones and
endian orders). The real test-case count, name by name, is in the dozens —
this report does not round it down to "one row per file" the way the
`test-census.sh` script would if run file-by-file; it is flagged here
instead because **no test-census was run against the upstream `tests/`
tree at all**: see gap below.

## Port census (`spec/`, `test/`)

```
spec/README.md                                — documentation only
spec/spec_helper.rb                            — harness bootstrap
spec/gnome_control_center/log_spec.rb          — new this pass
spec/gnome_control_center/object_storage_spec.rb — new this pass
test/drive_shell.rb                            — a drive script, now 26 check(...) calls
```

`find spec -name '*_spec.rb'` now returns 2 files (28 examples total,
confirmed by running `rspec spec` this session: "28 examples, 0 failures").
**These are still zero RSpec examples ported from any upstream
`.c`/`.py` test file** — `log_spec.rb` and `object_storage_spec.rb` test
the port's own new `Log`/`ObjectStorage` Ruby classes against the
behaviour described in `shell/cc-log.c`/`cc-object-storage.c`'s comments,
which is a reasonable thing to do since upstream's `tests/` tree (censused
below) has no file covering either one — the shell itself has no upstream
test directory. So: real, passing, and correctly not claimed against any
upstream test-file row in the table below. The only executable UI-driver
check in the repo is `test/drive_shell.rb`'s now-26 assertions, same
situation — shell/about/log/object-storage coverage, no upstream test file
is a port of any upstream test, because none of the upstream `tests/`
files covers the shell at all (upstream's shell has no `tests/` directory
of its own; its coverage is the panels').

## Bijection

0 of the ≥15 upstream test files/binaries have a named Ruby counterpart.
Every one of `test-hostname.c`, `test-time-entry.c`, `test-datetime.py`,
`test-endianess.c`, `test-timezone-gfx.c`, `test-timezone.c`,
`test-keyboard-shortcuts.c`, `test-keyboard.py`, `test-network-panel.c`,
`test-network-panel.py`, `test-wifi-text.c`, `test-canonicalization.c`,
`test-shift.c`, and the `interactive-panels` harness is a gap:

| Upstream test file | Purpose (one sentence) | Port test | State |
|---|---|---|---|
| `tests/common/test-hostname.c` | hostname validation/formatting against `hostnames-test.txt` fixtures | — | **gap** |
| `tests/common/test-time-entry.c` | the shared time-entry widget parses/validates clock input | — | **gap** |
| `tests/datetime/test-datetime.py` | datetime panel behaviour (timezone/format changes reach the UI) | — | **gap** |
| `tests/datetime/test-endianess.c` | date-field endian ordering matches locale | — | **gap** |
| `tests/datetime/test-timezone.c`, `test-timezone-gfx.c` | timezone lookup and map-widget rendering | — | **gap** |
| `tests/keyboard/test-keyboard-shortcuts.c` | shortcut parsing/binding logic | — | **gap** |
| `tests/keyboard/test-keyboard.py` | keyboard panel integration | — | **gap** |
| `tests/network/test-network-panel.c/.py`, `test-wifi-text.c` | network panel against a fake NM service; Wi-Fi string formatting | — | **gap** |
| `tests/printers/test-canonicalization.c` | printer-name canonicalization against `canonicalization-test.txt` | — | **gap** |
| `tests/printers/test-shift.c` | job time-shift calculation against `shift-test.txt` | — | **gap** |
| `tests/interactive-panels/*` | panel load/lifecycle harness | — | **gap** |

**Behaviour still owed** for every row above: the behaviour is owed the
moment the corresponding panel (keyboard, datetime/system, network,
printers, common) is ported — right now the behaviour owed is "the panel
does not exist," which is the component-identification/parity reports'
finding, and these test files are exactly the record of what that panel
must get right once it does.

## Does the port's own suite run?

Yes, mechanically, both of the port's two suites were run this session:

- `nix develop --command xvfb-run -a ruby test/drive_shell.rb` → "26 of 26
  checks passed / DRIVE OK".
- `nix develop --command xvfb-run -a ruby -e 'require "rspec/core"; exit
  RSpec::Core::Runner.run(["--format", "progress", "--require",
  "spec_helper", "spec"])'` → "28 examples, 0 failures".

Both results are real and reproducible, and both were re-run in this audit
rather than taken on faith from an earlier report. This is also the entire
executed test surface of the port: the 28 RSpec examples cover `Log` and
`ObjectStorage` only (no spec file exists for `window.rb`, `panel_list.rb`,
`about_panel.rb`, `system_info.rb`, `util.rb`, or `ui_util.rb` — confirmed,
`find spec -name '*_spec.rb'` lists exactly the two files named above), so
"the suite runs" and "the suite covers the port" remain two different
claims — only the first is established for most of the port's own files.
The 26/26 number in the task's runtime gate is `drive_shell.rb`; it proves
the shell+about+log+object-storage slice boots and behaves as asserted, and
proves nothing about the other 23 panels or about any of the upstream
`tests/` files, because none of them has a Ruby counterpart to run.

## Rules check

- No upstream test file is recorded as "n/a" or "C-specific" — every one is
  a stated behaviour still owed.
- The port's `drive_shell.rb` checks are real but are **not** credited
  against any upstream test row; they are extra coverage for code that
  itself has no upstream-test counterpart (the shell binary), listed below.

## Extra

- `test/drive_shell.rb` — 26 checks driving window title, about-panel data
  sourcing (including the disk-capacity row's real UDisks call),
  `Log`/`ObjectStorage` boot-wiring and singleton-guard behaviour, search
  mode toggle/filter/empty-state/row-activation, sidebar activation, and
  panel-registration count. All pass as of `b0f61703e`.
- `spec/gnome_control_center/log_spec.rb`,
  `spec/gnome_control_center/object_storage_spec.rb` — 28 RSpec examples
  total, unit-level coverage of the two new shell-support modules. All
  pass as of `b0f61703e`.
