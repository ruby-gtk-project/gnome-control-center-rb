# Translation parity — gnome-control-center-rb

| | |
|---|---|
| Upstream | `main` @ `a53c22ada` |
| Port | `ruby` @ `f8acc1220` |
| Upstream `po/POTFILES.in` entries | 302 |
| Upstream `po/LINGUAS` | 112 languages |
| Upstream msgids | not fully censused (see gap below); on the order of hundreds, drawn from 302 source files plus `.desktop.in`/metainfo/gschema strings per the skill |
| Port msgids | 0 |
| Port languages shipped | 0 |

## Census

`git show origin/main:po/POTFILES.in | wc -l` → 302 upstream files declared
as carrying translatable strings. `git show origin/main:po/LINGUAS` → 112
language codes. These are the two numbers the skill says anchor the claim;
a full msgid-by-msgid census (`msgid-census.sh`) was **not** run end to end
over all 302 files in this pass — doing so meaningfully requires the panels
those files belong to to exist on the port side to compare against, and 23
of 24 panels do not exist yet (see component-identification/-parity). What
was checked, and is unambiguous without a full census:

```
grep -rn "_(\|gettext\|require \"gettext\"\|require 'gettext'" lib/ exe/
```

returns **nothing**. Confirmed separately:

- `Gemfile`, `Gemfile.lock`, `gnome-control-center-rb.gemspec` — no
  `gettext` gem dependency anywhere.
- `find . -iname '*.po' -o -iname '*.pot'` (repo-wide, excluding `.git`) —
  no result.
- `find . -ipath '*locale*'` — no result; no `.mo` install path, no
  `LocaleData`, nothing.

## The three claims

1. **Key sets equal.** Upstream: hundreds of keys across 302 files.
   Port: **0**. Every upstream key is a gap by definition — there is no
   mechanism in the port that could produce a matching key, marked or not.
2. **Byte-identical keys.** N/A — there are no port keys to compare.
3. **Languages ship.** Upstream ships 112 (`po/LINGUAS`). Port ships **0**
   — no `po/` directory, no `.mo` build/install step, no gettext runtime
   dependency to load one even if a catalogue existed.

## What this means concretely, for the two units that do exist

`lib/gnome_control_center/window.rb` and `lib/gnome_control_center/panels/about_panel.rb`
build user-visible strings — the window title "Settings", row labels like
"Processor", "Memory", "OS Name", search placeholder text, etc. — as bare
Ruby string literals. Confirmed by reading both files: no `_()`, `N_()`,
`gettext`, or any translation call site appears anywhere in `lib/` or
`exe/`. Per the skill, this is not "English-only for now" — that phrasing
is itself one of the excuses the skill says to call a gap, not a state. It
is 112 languages' existing translations of these exact strings (upstream
ships "Settings", "Processor", etc. translated in `po/*.po` already) that
the port currently cannot surface for any locale, including the ones that
exist today in the same repository on `origin/main`.

## Rules check

- No row here is marked "n/a", "not applicable", or "i18n deferred" —
  the state is recorded as 0/N and the gap is total.
- No reworded-string nitpick is relevant yet, because there is no translation
  marking to check for a mismatched msgid; the gap is prior to that — nothing
  is marked at all.
- This report does not claim a false precise upstream total (e.g. "217
  msgids") it did not verify by running the full census; it states the two
  numbers that were verified (302 files, 112 languages) and says plainly
  that the full msgid diff is unexecuted, rather than presenting an estimate
  as a count.

## Gap to carry forward

Run `scripts/catalogue.rb <upstream-tree> --role upstream` and the
equivalent `msgid-census.sh` once a `gettext`-equivalent call is actually
wired into the port (it is not, as of this commit), so that the first
msgid the port ever marks is checked against upstream's byte-for-byte from
that commit on, instead of retrofitted later.
