---
name: proposal-generator
description: Create, revise, and finalize client proposals from brief notes, meeting summaries, or direct user input. Use when the user asks for a proposal, business proposal, technical proposal, partnership proposal, statement of work, pricing proposal, proposal wizard, or proposal draft/final HTML/PDF assets. Supports template selection, theme selection, draft generation, and reusable proposal assets for OpenClaw.
---

# Proposal Generator

Create proposals in two stages: draft first, final render second.

## Use this folder layout

```text
proposal-generator/
├── assets/
│   ├── proposal-template.html
│   └── SERVICES-template.md
├── references/
│   └── workflow.md
└── templates/
    ├── business-kor.md
    ├── technical-kor.md
    └── partnership-kor.md
```

When producing user deliverables in a workspace or project, prefer this output layout:

```text
proposals/
├── primary-source/
├── test-fixtures/
├── meta/
├── context/
├── generated/
├── revisions/
├── tone-packs/
└── SERVICES.md
```

## Operating rules

- Gather context from the user, pasted notes, local docs, or meeting summaries.
- Before drafting, classify the current step as one of: META, PRIMARY SOURCE, or TEST FIXTURE.
- If real user/client materials exist, treat `proposals/primary-source/` as the source of truth.
- Keep test fixtures isolated and never let them silently influence final outputs.
- If key inputs are missing, ask only for the minimum needed to draft.
- Start with markdown draft output before generating polished HTML.
- Prefer Korean by default unless the user asks for English.
- Keep tone practical and decision-oriented.
- Separate assumptions from confirmed facts.
- If pricing is unknown, mark placeholders clearly instead of inventing numbers.

## Workflow

1. Choose mode: create, compare, or revise.
2. Choose proposal type: business, technical, partnership, or custom.
3. Choose a template from `templates/`.
4. Create `proposals/context/` notes if source material needs normalization.
5. In compare mode, produce both an `original`-style draft and a `custom` draft from the same input.
6. Save drafts in `proposals/generated/` with distinguishable names.
7. In revise mode, load the latest proposal plus new notes/change requests, then create a new versioned draft in `proposals/revisions/` or `proposals/generated/`.
8. Revise sections interactively.
9. Finalize into HTML using `assets/proposal-template.html` and a selected theme/CSS strategy.

## Template selection

- `business-kor.md`: sales, service, consulting, agency, general business proposals
- `technical-kor.md`: system build, platform delivery, implementation, architecture, operations
- `partnership-kor.md`: partnership, alliance, PoC, collaboration, joint go-to-market

## Tone-pack selection

Treat visual/message tone as a replaceable layer.

- Keep reusable tone references in `proposals/tone-packs/` or skill-level `references/tones/`
- When the user shares a PPT, deck, cover sample, or proposal style, extract its headline patterns, metaphors, pacing, and closing language into a tone-pack note
- Reuse the selected tone-pack in future proposals until the user changes direction
- If tone guidance grows too large, split by design family instead of bloating one SKILL file

## Finalization guidance

When rendering HTML:
- inject the completed markdown content into the base template
- fill proposal metadata (`title`, `client_name`, `date`, `valid_until`, `company_name`)
- keep the layout print-friendly
- ensure mobile readability

## Revision rules

- Treat proposals as living documents, not one-shot outputs.
- When additional notes or requirements arrive, update the latest proposal instead of starting from zero.
- Preserve revision history with versioned files such as `client-proposal.v2.md`.
- Record the change reason in a nearby context or change-request file.
- In compare mode, always keep original-style and custom outputs side by side for the same source input.

Read `references/workflow.md` before creating or restructuring proposal outputs.
Read `references/tones.md` when selecting or extending tone-packs.
If real proposal materials are present, also follow `proposals/meta/source-discipline.md` and keep outputs anchored to `proposals/primary-source/`.
