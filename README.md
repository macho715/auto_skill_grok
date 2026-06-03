auto_skill_grok

Grok-native 'auto' self-improving SDLC skill with gstack (https://github.com/garrytan/gstack.git) as the mstack layer.

## Installation

Clone with submodules:
git clone --recurse-submodules https://github.com/macho715/auto_skill_grok.git

Or after clone:
git submodule update --init --recursive

Then place/symlink the auto/ dir to your Grok skills location (~/.grok/skills/auto).

The mstack-* skills are provided by the gstack submodule (careful/, review/, qa/, ship/, investigate/, retro/, autoplan/, etc.).

Junctions or copies are used in installed locations to point to gstack/ subdirs.

See SKILL.md for full details, including the actual pipeline run + gstack integration verification.

## gstack Integration

- gstack is included as submodule.
- Local dev copy may be at gstack-main/ in source.
- Used stages: careful, plan (autoplan), review, qa, ship, investigate, retro, etc.

## Recent Work
- Full auto pipeline executed with gstack mstack.
- Parallel review and QA subagents.
- Patches applied and verified.
- All skill files + gstack reference uploaded.
