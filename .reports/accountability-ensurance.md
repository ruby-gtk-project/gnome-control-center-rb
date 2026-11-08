# Accountability ensurance — gnome-control-center-rb

Grepped: `lib/`, `exe/`, `.reports/`, and the repo root for `PORTING.md` (does
not exist). Pattern set: `TODO`, `FIXME`, `not implemented`, `for now`,
`in a future`, plus the skill's own excuse vocabulary (`out of scope`,
`not applicable`, `n/a`, `by design`, `deferred`, `does not carry over`,
`dropped deliberately`).

```
grep -rniE "TODO|FIXME|not implemented|for now|in a future|out of scope|not applicable|n/a\b|by design|deferred|does not carry over|dropped deliberately" lib/ exe/ PORTING.md .reports/
```

## Finding 1 — a real excuse, in code, for a real missing feature

`lib/gnome_control_center/window.rb:79-81`:

```ruby
# Upstream's cc_window_set_active_panel_from_id. Parameters beyond the
# target subpage tag (upstream's GVariant `parameters`) are out of scope
# for this port, since nothing yet activates the shell with one.
def activate_panel(id, subpage_tag: nil)
```

This is exactly the pattern the skill names: a neutral-sounding sentence
that converts a missing feature (upstream's full `GVariant *parameters`
deep-link payload — used by the search provider and CLI/D-Bus panel
activation to jump straight to a sub-page with arguments, not just a tag)
into something that reads as a decision. "Out of scope" is not available to
the writer: upstream shipped this parameter, so it is in scope by the
skill's own premise. "Since nothing yet activates the shell with one" is
also not a reason — the search provider and `--panel` launches with
parameters are exactly the things that would, and they are two of the
unported units this audit's other reports list as gaps (search-provider is
0/2 files per component-identification; the shell CLI entry point
`lib/gnome_control_center/application.rb` installs no parameterized
activation path at all).

Correct statement for this comment: the agent that wrote `activate_panel`
did not carry upstream's parameter payload through, full stop — no
qualifier. The behaviour still owed is: a panel can be activated with
whatever extra data upstream's `GVariant` would have carried (subpage plus
arguments), and today it cannot.

## Finding 2 — the runtime gate must not be read wider than it is

The task's own gate (this round): `drive_ok=true, 26 checks passed, 0
failed, covering 8 components`. This audit verified that run directly
(`nix develop --command xvfb-run -a ruby test/drive_shell.rb` → "26 of 26
checks passed / DRIVE OK", confirmed this session) and also ran the
project's separate RSpec suite, which the task does not mention as part of
the gate (`rspec spec` → "28 examples, 0 failures", also confirmed this
session). Both numbers are real and not fabricated. The risk the skill
warns about is reading 26/26 (or 26+28) green as "the app works" rather
than "the shell plumbing, one panel, and two boot-wired support modules
work." No document in this repo currently makes that overreach explicit —
not README, not CHANGELOG (checked: neither contains "complete", "parity",
"finished", or "all panels"), not any commit message read in this pass.
That is a genuine clean result, not a gap, and it is worth recording
precisely because the other four reports in this round establish how far
short of "the app" 26/26 actually is: 1 of 24 panels, partially; 2 more
panels (`sharing`, `sound`) with one inert enum file each and no panel; 0
of ≥15 upstream test files ported; 0 of ~302 translatable-string source
files covered. The gate passing is accurate about what it covers and an
auditor (or the next agent) must not inflate "8 components, 26/26" into
"parity" — that inflation has not happened yet in this repo's own
documents, but it is the single easiest way the next PR could manufacture
a false green, and this line exists so the next reader checks before
repeating it.

## Finding 2a — two of this round's "8 components" are wired but inert, not working

`log.rb` and `object_storage.rb` (new this round) are each called exactly
once, at boot, from `Application#build` (`Log.init`,
`ObjectStorage.initialize_storage`) — confirmed by reading
`application.rb` and by grepping for any other call site:
`grep -rn "Log\."` outside `log.rb`/`application.rb` and
`grep -rn "ObjectStorage\."` outside `object_storage.rb`/`application.rb`
each return only the boot call and the `drive_shell.rb`/spec assertions
that check the singleton guard fires correctly. Neither module ever logs a
real event or caches a real D-Bus proxy anywhere in this port, because no
panel that would do either exists yet. This is not an excuse-shaped
sentence anywhere in the code — `log.rb`'s own comment correctly describes
a real ruby-gnome binding gap (no `GLib.log_set_writer_func` equivalent)
rather than hand-waving away the lack of real callers — but it is exactly
the shape of finding this skill asks for: a drive check passing ("a second
`initialize_storage` call refuses") can read as "ObjectStorage works" when
what it actually demonstrates is "the guard clause works"; whether caching
and retrieving a real proxy works is, today, not exercised by anything.
Likewise `panels/common/ui_util.rb`, `panels/sharing/gsd_sharing_enums.rb`,
and `panels/sound/sound_enums.rb` (also new this round) have zero callers
anywhere outside their own defining files — faithful, correct ports of
upstream code that currently do nothing, because the panels that would
call them do not exist. `component-parity.md` records all of this in
detail; this finding exists so a reader of the drive-gate number alone,
without reading `component-parity.md`, does not credit these files as
proven working behaviour.

## Finding 3 — no ledgers exist yet, so no ledger can lie

Per the skill's own cross-reference table, a port carries up to four
documents: `PORTING.md`, `TEST_PARITY.md`, `COMPONENT_PARITY.md`,
`FINDINGS.md`. None exists on `ruby` as of `b0f61703e`
(`find . -iname 'PORTING.md' -o -iname 'FINDINGS.md' -o -iname
'TEST_PARITY.md' -o -iname 'COMPONENT_PARITY.md'` → no result outside this
audit's own `.reports/` files). There is therefore no ledger currently
citing itself as authority for a skip — the specific failure mode the skill
exists to catch (console-rb's "Dropped deliberately" section) has not
happened here **yet**, for the simple reason that almost nothing has been
built. This is not evidence the port is clean; it is the absence of the one
mechanism (a stale ledger) that would hide the gap, which the other four
reports establish in full regardless.

## Finding 4 — the opening survey's own scoping language, checked against the skill

`.reports/component-inventory.md` contains "out of scope for this survey"
(line ~512, about the `po/` catalogue) and "Not covered by this pass"
(tests/, subprojects/, build-aux/, .gitlab-ci/, man/, docs/,
`.desktop.in`/`.policy.in` launchers). Read against the skill: these are
**not** the excuse pattern, because they scope an *inventory document*
("what did this survey count"), not a *missing application feature*
("why doesn't the port do X"). The survey explicitly hands the `po/` work
to `translation-parity` and the `.desktop.in`/`.policy.in` work to whichever
agent ports the panel that needs it, rather than declaring either one done
or unnecessary. Judged against Finding 1's actual code comment, this is the
correct way to write a scoping note; Finding 1 is the wrong way. Both exist
in the same repo, which is why they are both recorded here rather than
treating "a scoping note was found" as itself the violation.

## Verdict

One excuse-shaped sentence found and quoted above (Finding 1), sitting on a
real, uncredited gap, unchanged from the previous round. Two more files new
this round (`log.rb`, `object_storage.rb`) are wired at boot but currently
inert for their actual purpose (Finding 2a), and three more new files
(`ui_util.rb`, `gsd_sharing_enums.rb`, `sound_enums.rb`) have no caller at
all. No false "done"/"parity"/"complete" claim found anywhere in the
repo's prose. The repo's silence (no PORTING.md, no FINDINGS.md) is itself
flagged because silence is where the next false green would get written
once panels start landing — this report is the marker that the gate's
26/26 must always be read as "8 components of 24+ panels, two of which are
boot-wired but not yet doing their actual job," never rounded up.
