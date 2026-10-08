# Skill 2: Agent Editing Safety

- Never create backup files such as `.bak`, `.old`, `.backup`, `_copy`, `_new`, or duplicated files.
- Never rewrite an entire file unless explicitly required.
- Always preserve existing logic unless the user asks to change it.
- Before editing, identify the exact files and symbols to modify.
- Make minimal, targeted changes only.
- After each edit, review the diff.
- If a later edit conflicts with an earlier edit, preserve both requirements and refactor instead of overwriting.
- Never delete existing code without explaining why it is safe.
- Do not rename files, classes, methods, routes, providers, blocs, controllers, or models unless explicitly requested.
- Do not change project architecture unless explicitly requested.
- After editing, run:
    - fvm dart format .
    - fvm flutter analyze
- If analyze fails, fix the issue before finishing.