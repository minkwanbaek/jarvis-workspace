# Tone packs

Treat proposal tone as modular. Do not hard-code every style into the main SKILL.md.

## Operating rule

When the user shares reference material such as:
- PPT covers
- proposal PDFs
- landing pages
- brand messaging docs
- sales decks

extract these into a reusable tone-pack:
- headline pattern
- problem framing pattern
- solution framing pattern
- emotional posture
- Korean/English tagline style
- closing statement style
- words to prefer
- words to avoid

## Storage strategy

Use one of these patterns depending on scale:

### Small scale
Store lightweight notes in:
- `proposals/tone-packs/<name>.md`

### Larger scale
Split by design family in the skill folder:
- `references/tones/bold-b2b.md`
- `references/tones/executive-formal.md`
- `references/tones/visionary-brand.md`
- `references/tones/minimal-technical.md`

## Recommended structure for each tone-pack

```markdown
# Tone Pack: <name>

## Source references
- file / deck / URL

## Core message
- ...

## Headline formula
- ...

## Problem framing
- ...

## Solution framing
- ...

## Preferred expressions
- ...

## Avoid
- ...

## Example opener
- ...

## Example closer
- ...
```

## Use rule

When generating proposals:
1. choose template
2. choose tone-pack
3. generate original/custom outputs if in compare mode
4. keep the tone-pack stable across revisions unless the user changes it
