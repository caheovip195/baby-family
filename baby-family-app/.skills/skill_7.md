# Skill 7 : Flutter Project Architecture

## Goal

Strictly follow the existing project architecture, dependency flow, folder structure, and coding conventions.

These rules are mandatory.

---

# Architecture Flow

All business logic must follow this execution flow:

```
Page
   ↓
Controller
   ↓
Service
   ↓
Repository
   ↓
Remote API / Local Storage
```

Never bypass any layer.

---

# UI Layer

Pages are responsible only for:

- Rendering UI
- Receiving user interactions
- Calling Controller methods

Pages MUST NOT:

- Call Repository directly
- Call Service directly
- Perform business logic
- Perform data transformation
- Access API
- Access database

Always communicate through the Controller.

---

# Controller Layer

Controllers are responsible for:

- Receiving events from the UI
- Validating input
- Coordinating business logic
- Calling Services
- Updating UI state

Controllers MUST NOT:

- Access Repository directly
- Contain networking code
- Contain database logic

---

# Service Layer

Services are responsible for:

- Business logic
- Combining multiple repositories
- Data processing
- Validation

Services MUST communicate with Repositories only.

Services MUST NOT:

- Access UI
- Access Widgets
- Access BuildContext

---

# Repository Layer

Repositories are responsible for:

- API communication
- Local database
- Cache
- Data source abstraction

Repositories MUST NOT contain business logic.

---

# Model Rules

Entity/Data models MUST be placed in:

```
lib/data/model
```

DTO models MUST be placed in:

```
lib/data/dto
```

Never mix DTOs and Models.

Never place models outside these directories.

---

# Dependency Injection

All Services and Repositories MUST use Dependency Injection.

Repository example:

```dart
abstract class IUserRepository extends IBaseRepository {}

class UserRepositoryImp
    extends BaseRepository
    implements IUserRepository {}
```

Service example:

```dart
abstract class IUserService extends IBaseService {}

class UserServiceImp
    extends BaseServiceImp
    implements IUserService {}
```

Never instantiate repositories or services using:

```dart
UserRepository()
UserService()
```

Always obtain instances through the project's Dependency Injection system.

---

# Shared Widgets

Reusable widgets MUST be placed in:

```
lib/utils/widget
```

Never duplicate common widgets.

Always reuse existing widgets whenever possible.

---

# Helpers

Helper classes MUST be placed in:

```
lib/utils/helper
```

Do not create helper classes elsewhere.

---

# Project Structure

Always follow the existing project structure.

Never:

- Create new architecture
- Create new folder structures
- Introduce another design pattern
- Introduce another state management solution
- Introduce another networking solution
- Move existing files without permission

When similar code already exists, follow the existing implementation instead of creating a new pattern.

---

# Before Coding

Before implementing any feature:

1. Inspect the existing project.
2. Find similar implementations.
3. Reuse existing architecture.
4. Determine the correct layer.
5. Modify only the required files.

---

# Self Validation

Before completing any task, verify:

- No architecture rule was violated.
- Page only communicates with Controller.
- Controller only communicates with Service.
- Service only communicates with Repository.
- Repository only communicates with data sources.
- All models are under `lib/data/model`.
- All DTOs are under `lib/data/dto`.
- All repositories use Dependency Injection.
- All services use Dependency Injection.
- Shared widgets are under `lib/utils/widget`.
- Helpers are under `lib/utils/helper`.
- No unnecessary files or folders were created.

# Existing Code First

Before creating any new class, widget, helper, repository, service, DTO, model, or utility:

- Search the project for an existing implementation.
- Reuse it whenever possible.
- Never create duplicate functionality.
- Extend or modify the existing implementation instead of creating a new one.

Duplicate implementations are considered architecture violations.

If any rule is violated, refactor the implementation before responding.