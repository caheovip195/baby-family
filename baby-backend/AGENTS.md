# Backend conventions

Follow the user's chosen OOP architecture: **controller → service → repository → model**. Organize source by role, with global `controllers/`, `services/`, `repositories/`, `models/`, `interfaces/services/`, `interfaces/repositories/`, `dto/`, `database/`, `config/`, `common/` and `workers/` directories. `workers/` (approved 2026-10-15) holds only the worker entrypoint, its composition root and queue/loop adapters that call service interfaces. Keep this structure when adding resources; do not introduce feature modules or domain/application/infrastructure/presentation subtrees.

- Controllers handle HTTP/DTOs and inject service interfaces. Business rules and orchestration belong in services.
- Use `NoteService implements INoteService` and `NoteRepository implements INoteRepository` naming, following the same pattern for other resources.
- Interfaces and their exported Symbol tokens live together. Bind tokens to implementations in `AppModule`; inject dependencies using `@Inject(TOKEN)` and the interface type.
- Repositories own all Prisma CRUD, queries, transactions and row-to-model mapping. Services never import Prisma or concrete repositories.
- Models are classes containing table attributes and instance helpers. They do not query databases, inject services or orchestrate business workflows. Repositories return model instances, not raw Prisma rows.
- DTOs live under `dto/<resource>/`, with shared HTTP DTOs in `dto/common/`. Services/repository contracts may use DTO types via `import type`. Keep Prisma types inside database/repository code.
- `database/` owns the shared Prisma connection and its lifecycle. Infrastructure health checks may probe it directly.
- PostgreSQL server/Compose, host data and backups belong in `../baby-database/`. Backend Compose only owns API/migrations and connects through the external database network. Keep Prisma schema/migrations and the TypeScript connector here; do not put the database server back into backend Compose.
- Keep generated code aligned with these conventions. Use `npm run generate -- resource <singular-kebab-name>` and preserve generator markers in AppModule.
- Tests live under `test/unit/`, `test/e2e/`, and `test/integration/`. After refactoring, run `npm run check`; run `npm run test:integration` when persistence or DI wiring changes. Integration databases must end in `_test`.
- Build/typecheck/watch use native TypeScript 7 through the package scripts; do not replace them with Nest CLI compilation, which uses the legacy Compiler API. The `typescript` alias intentionally supplies TS6 compatibility for Jest, typed ESLint, AST generators and `ts-node`. Keep this distinction explicit; see [TypeScript toolchain](docs/typescript-7.md). `npm run test:compiled` checks the actual emitted JavaScript and Nest decorator metadata. Seed uses `tsconfig.tools.json` so fresh Prisma NodeNext `.js` imports resolve to `.ts` sources; keep seed explicit and separate from migrations/startup.

See `README.md` for commands and `docs/architecture.md` for responsibilities and DI examples.

## Mandatory database and job rules

- Migrations are DDL only: no INSERT/UPDATE/DELETE/MERGE/TRUNCATE, catalog seed or business CRUD. Seed data lives in `prisma/seed.ts`/`prisma/seeds/` and runs explicitly with `npm run db:seed`; never auto-seed on migrate/start. Prisma schema/migrations belong to this backend, not `baby-database`. Run `npm run prisma:check-migrations`; review SQL functions/DO blocks as well. Do not edit already applied migrations.

- Follow [extensibility standards](../.agents/skills/baby-family-team/references/extensibility-standards.md): plans, quotas, capabilities and trial policy are versioned catalog/config data. Default trial is 7 days. Authorize by server capabilities, not a fixed list of plan names; preserve typed validation, backward compatibility and OOP/DI. Adding a plan using supported features must not require schema enum changes.

- Read [database standards](../.agents/skills/baby-family-team/references/database-standards.md) before schema, migration, model, repository or generator work. Every project-owned table, including explicit join tables, outbox and job/history tables, must have `created_at`, `updated_at`, `deleted_at`. Do not modify PostgreSQL/Prisma/package-owned internal tables to add these fields.
- Use `timestamptz(3)`: created/updated are non-null with `now()` defaults, deleted is nullable. Prisma/TS names are `createdAt`, `updatedAt`, `deletedAt`, mapped to snake_case. Migrations must provide an `updated_at` DB trigger for all writers; Prisma `@updatedAt` alone does not cover raw SQL.
- Business removal defaults to soft delete. Repositories filter active rows consistently across reads/counts/updates/relations with tenant scope. Restore/purge need explicit methods and retention/uniqueness rules. Keep schema, model, migration, repository and generator aligned when implementing changes.
- Follow [job rules](docs/jobs.md) for cron/workers: service interfaces/DI, durable PostgreSQL run/attempt history, bounded business-job retries, idempotency, lease/crash recovery and external outage alerts. Scheduler callbacks contain no Prisma/business logic.
- These are required implementation standards. Updated 2026-10-14: Prisma schema, forward migration, Note/resource generator and domain persistence include the audit/soft-delete conventions. Domain service/interface coverage and selected controllers/auth boundary are implemented; see [API scope](docs/api.md). Internal generated services are scaffolding, not complete workflows. Schema/seed deployment is separate from generating code; Store/identity issuance, Circle/private-content ACL, jobs and full domain workflows are not implemented. Do not claim runtime compliance without applying migrations and relevant checks to that environment.

- Keep HTTP DTOs and response projections separate from persistence inputs/models. Never expose generic CRUD for billing/ledger/joins/jobs/session secrets or private `us` content. Domain controllers use verified `CurrentActor` with `AccessTokenGuard`; client headers/body never choose actor, role or privileged scope. Services check current membership/lifecycle/entitlement, not JWT family/role claims or plan names. Keep Prisma out of services/controllers. Internal service generation has a separate hash guard (`npm run generate:services -- --check`); preserve handwritten business services.

## Project roles and mandatory history

For every request, including explanation-only questions, follow [root AGENTS.md](../AGENTS.md) and [baby-family-team](../.agents/skills/baby-family-team/SKILL.md). Select the relevant roles before work; use independent sub-agents when useful. The primary agent must record each user question, date, roles, concise analysis and actual results in both root [SESSIONS.md](../SESSIONS.md) and [PRODUCT_ANALYTICS_HISTORY.md](../PRODUCT_ANALYTICS_HISTORY.md). Backend conventions above remain mandatory.
