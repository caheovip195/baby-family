# Backend conventions

Follow the user's chosen OOP architecture: **controller → service → repository → model**. Organize source by role, with global `controllers/`, `services/`, `repositories/`, `models/`, `interfaces/services/`, `interfaces/repositories/`, `dto/`, `database/`, `config/`, and `common/` directories. Keep this structure when adding resources; do not introduce feature modules or domain/application/infrastructure/presentation subtrees.

- Controllers handle HTTP/DTOs and inject service interfaces. Business rules and orchestration belong in services.
- Use `NoteService implements INoteService` and `NoteRepository implements INoteRepository` naming, following the same pattern for other resources.
- Interfaces and their exported Symbol tokens live together. Bind tokens to implementations in `AppModule`; inject dependencies using `@Inject(TOKEN)` and the interface type.
- Repositories own all Prisma CRUD, queries, transactions and row-to-model mapping. Services never import Prisma or concrete repositories.
- Models are classes containing table attributes and instance helpers. They do not query databases, inject services or orchestrate business workflows. Repositories return model instances, not raw Prisma rows.
- DTOs live under `dto/<resource>/`, with shared HTTP DTOs in `dto/common/`. Services/repository contracts may use DTO types via `import type`. Keep Prisma types inside database/repository code.
- `database/` owns the shared Prisma connection and its lifecycle. Infrastructure health checks may probe it directly.
- Keep generated code aligned with these conventions. Use `npm run generate -- resource <singular-kebab-name>` and preserve generator markers in AppModule.
- Tests live under `test/unit/`, `test/e2e/`, and `test/integration/`. After refactoring, run `npm run check`; run `npm run test:integration` when persistence or DI wiring changes. Integration databases must end in `_test`.

See `README.md` for commands and `docs/architecture.md` for responsibilities and DI examples.

## Project roles and mandatory history

For every request, including explanation-only questions, follow [root AGENTS.md](../AGENTS.md) and [baby-family-team](../.agents/skills/baby-family-team/SKILL.md). Select the relevant roles before work; use independent sub-agents when useful. The primary agent must record each user question, date, roles, concise analysis and actual results in both root [SESSIONS.md](../SESSIONS.md) and [PRODUCT_ANALYTICS_HISTORY.md](../PRODUCT_ANALYTICS_HISTORY.md). Backend conventions above remain mandatory.
