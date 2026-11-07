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

The task's own gate: `drive_ok=true, 20 checks passed, 0 failed, covering 7
components`. This audit verified that run directly
(`nix develop --command xvfb-run -a ruby test/drive_shell.rb` → "20 of 20
checks passed / DRIVE OK", confirmed this session). The number is real and
not fabricated. The risk the skill warns about is reading 20/20 green as
"the app works" rather than "the shell plumbing and one panel work." No
document in this repo currently makes that overreach explicit — not README,
not CHANGELOG (checked: neither contains "complete", "parity", "finished",
or "all panels"), not any commit message read in this pass. That is a
genuine clean result, not a gap, and it is worth recording precisely
because the other four reports in this round establish how far short of
"the app" 20/20 actually is: 1 of 24 panels, partially; 0 of ≥15 upstream
test files ported; 0 of ~302 translatable-string source files covered. The
gate passing is accurate about what it covers and an auditor (or the next
agent) must not inflate "7 components, 20/20" into "parity" — that
inflation has not happened yet in this repo's own documents, but it is the
single easiest way the next PR could manufacture a false green, and this
line exists so the next reader checks before repeating it.

## Finding 3 — no ledgers exist yet, so no ledger can lie

Per the skill's own cross-reference table, a port carries up to four
documents: `PORTING.md`, `TEST_PARITY.md`, `COMPONENT_PARITY.md`,
`FINDINGS.md`. None exists on `ruby` as of `f8acc1220`
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
real, uncredited gap. No false "done"/"parity"/"complete" claim found
anywhere in the repo's prose. The repo's silence (no PORTING.md, no
FINDINGS.md) is itself flagged because silence is where the next false
green would get written once panels start landing — this report is the
marker that the gate's 20/20 must always be read as "7 components of 24+
panels," never rounded up.
