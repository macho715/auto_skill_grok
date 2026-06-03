auto_skill_grok

Grok-native 'auto' self-improving SDLC skill with gstack (https://github.com/garrytan/gstack.git) as the mstack layer.

## Installation

For Grok TUI:
- Place the contents under `~/.grok/skills/auto/`
- The mstack-* are registered globally via junctions or copies pointing to gstack-main or installed gstack.

See SKILL.md for usage (FEATURE, BUGFIX, FAST pipelines).

## gstack Integration

- mstack-careful, mstack-plan (autoplan), mstack-review, mstack-qa, mstack-ship, mstack-investigate, mstack-retro are wired to gstack sub-skills.
- Local gstack source: gstack-main/ (cloned for live junctions).
- Basic shims for mstack-dispatch, mstack-pipeline, mstack-implement.

## Recent Patches (actual auto run + parallel review/QA)
- Full pipeline executed with todos, careful (varlock), parallel subagents for review + QA.
- Patches applied from review (docs credits, cleanups, mstack-implement added).
- Verified PASS.
- Retro and logs included.

See retro-gstack-integration.md and varlock-gstack-scan.log for details.

Self-upgrade rule: after edits to auto files, run auto-self-upgrade.ps1 (or .sh).