# Proposal workflow

## 1. Normalize inputs

Collect and normalize these fields when available:
- client / counterpart name
- proposal objective
- background / problem
- proposed solution
- scope
- schedule
- pricing / budget
- assumptions
- decision deadline
- call to action

If the user provides messy notes, convert them into a short context memo first.

## 2. Drafting pattern

Use this sequence:
1. cover/meta
2. background or problem definition
3. objective
4. proposed approach
5. scope / deliverables
6. timeline
7. pricing / commercial terms
8. assumptions / exclusions
9. next steps

## 2A. Compare mode

When validating the custom skill, always generate two outputs from the same normalized input:
- `*.original.md`: close to the original skill's framing and section style
- `*.custom.md`: the OpenClaw/Jarvis version

The normalized input must be explicitly labeled as either PRIMARY SOURCE or TEST FIXTURE before drafting.

Then compare:
- clarity of problem statement
- scope precision
- suitability for Korean business context
- editability when new notes arrive
- commercial readability

Prefer the custom version only when it is clearly better on these dimensions.

## 2B. Revision mode

When new notes arrive:
1. load the latest proposal
2. identify whether the new notes come from PRIMARY SOURCE or TEST FIXTURE material
3. extract requested changes
4. write a change-request memo in `proposals/context/` or `proposals/revisions/`
5. produce a new versioned file (`v2`, `v3`, ...)
6. summarize what changed

## 3. Quality bar

A good proposal should:
- make the reader's problem explicit
- show why this approach is suitable now
- avoid vague hype
- make scope boundaries obvious
- make the next decision easy

## 4. Korean-first tone

Default tone should be:
- formal but not stiff
- practical
- concise
- executive-readable

## 5. Final outputs

Recommended files:
- `proposals/context/YYYY-MM-DD_client-topic.md`
- `proposals/generated/YYYY-MM-DD_client-proposal.md`
- `proposals/generated/YYYY-MM-DD_client-proposal.html`
