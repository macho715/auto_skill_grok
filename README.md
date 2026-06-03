auto_skill_grok

Grok-native 'auto' self-improving SDLC skill with gstack (https://github.com/garrytan/gstack.git) as the mstack layer.

## Installation

git clone --recurse-submodules https://github.com/macho715/auto_skill_grok.git

The gstack/ directory contains the core SKILL.md files for the mstack stages that auto uses (careful/, review/, qa/, ship/, investigate/, retro/, autoplan/ for plan, etc.).

The full gstack is available via the submodule at gstack/ (after submodule update).

Place or symlink the auto/ content to your ~/.grok/skills/auto/.

Junctions or copies in installed skills point mstack-* to the gstack sub skills.

See SKILL.md for the full M-Stack (gstack) section, including the actual pipeline execution and parallel review/patch verification that was performed.

## gstack Files Used by Auto

- gstack/SKILL.md : main gstack framework
- gstack/careful/SKILL.md : mstack-careful
- gstack/review/SKILL.md : mstack-review
- gstack/qa/SKILL.md : mstack-qa
- gstack/ship/SKILL.md : mstack-ship
- gstack/investigate/SKILL.md : mstack-investigate
- gstack/retro/SKILL.md : mstack-retro
- gstack/autoplan/SKILL.md : mstack-plan

(And others like guard, freeze if used in careful flows.)

These are the files uploaded alongside the auto skill for complete self-contained usage.

## Recent Patches
- Integrated gstack as mstack.
- Actual auto pipeline run with parallel subagents for review and QA.
- Patches applied from review feedback.
- All verified PASS.
- Retro and logs included.

Run auto-self-upgrade after any edits to auto files.