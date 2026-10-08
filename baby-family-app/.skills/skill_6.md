# Skill 6: Server Data Request Architecture

## Goal

Every request to the backend must follow the existing Flutter mobile data
architecture. Do not put ad hoc network calls in services, providers,
controllers, widgets, or pages.

## Mandatory Flow

For every new backend endpoint or server mutation, implement in this order:

1. Add or reuse the endpoint constant in `lib/utils/constants/server.dart`.
2. Add the Retrofit method in `lib/data/remote/app_client/app_client.dart`.
3. Put auth/retry metadata on the Retrofit method with `@Extra` when needed.
4. Add the method to the correct repository contract in `lib/data/repository/`.
5. Implement the method in `lib/data/repository_imp/` by calling `client!...`.
6. Add a service contract method in `lib/data/service/` only when callers need it.
7. Implement orchestration/mapping/cache/offline logic in `lib/data/service_imp/`.
8. Expose data through providers in `lib/data/provider/`.
9. Let presentation controllers/pages consume providers or service interfaces only.
10. Run code generation after changing Retrofit:
    `fvm dart run build_runner build`

## Layer Responsibilities

- `utils/constants/server.dart`: endpoint paths only.
- `data/remote/app_client`: Retrofit declarations only.
- `data/repository`: backend/local storage contracts only.
- `data/repository_imp`: the only normal place to call `AppClient` for API data.
- `data/service_imp`: combines repository calls, maps domain data, handles
  fallback/offline/sync orchestration, but does not own raw HTTP calls.
- `data/provider`: Riverpod wiring and cache invalidation.
- `page`: UI state and user interaction only.

## Forbidden

Never add server data requests using:

- `AppServiceDio.getInstance()!.get(...)` or `.post(...)` in `service_imp`,
  `provider`, `presentation`, widgets, controllers, or pages.
- raw `Dio()` for product API calls outside Dio config/interceptors.
- hard-coded API paths outside `utils/constants/server.dart` and generated code.
- repository calls directly from presentation pages/widgets.
- parsing backend response maps in UI widgets or controllers.

Allowed exceptions:

- Dio bootstrap/config/interceptors in `lib/data/remote/**`.
- `BaseRepositoryImp` using `AppServiceDio.appClient` and transfer progress helpers.
- Reading the configured base URL for media playback when no server request is
  executed there.

## Model and Mapping Rules

- New request/response models belong in `lib/data/model/`.
- Follow Skill 3 Freezed/json_serializable rules for new models.
- Keep DTO-to-domain mapping in `lib/data/dto/` or `data/service_imp/`, matching
  existing patterns.
- Do not invent mock fallback data when backend requests fail.
- Preserve server field naming and use `Api` constants instead of duplicating
  endpoint strings.

## Media upload

- Ảnh/video KHÔNG gửi qua API server: xin `upload-intents` (presigned URL) qua
  repository rồi tải trực tiếp lên object storage (tài liệu kỹ thuật mục 10).
- Mọi POST thay đổi trạng thái quan trọng gửi `Idempotency-Key` và giữ nguyên
  key khi retry.

## Self Validation

Before finishing any server-data task, run these checks:

```bash
rg -n "AppServiceDio|getInstance\\(|Dio\\(|\\.get\\('/v1|\\.post\\('/v1" lib \
  -g '*.dart'
rg -n "'/v1|\\\"/v1" lib \
  -g '*.dart' \
  -g '!**/data/remote/app_client/app_client.g.dart'
fvm dart run build_runner build
fvm flutter analyze
```

Any new match outside the allowed files must be fixed before responding.
