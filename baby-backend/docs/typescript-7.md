# TypeScript 7.0.2 trong Baby Family Backend

Cập nhật nghiên cứu ngày **15/10/2026**, tiếp nối BF-20261014-004. Compiler build/typecheck chuyển sang **TypeScript 7.0.2 native**; tooling cần Compiler API dùng gói tương thích TypeScript 6 riêng.

## 7.0.2 có gì mới?

`7.0.2` là bản **ổn định đầu tiên của nhánh 7.0**, phát hành **08/07/2026**. Trước đó là [7.0.0-beta](https://devblogs.microsoft.com/typescript/announcing-typescript-7-0-beta/) và [7.0.1-rc](https://devblogs.microsoft.com/typescript/announcing-typescript-7-0-rc/). [Release gốc](https://github.com/microsoft/typescript-go/releases/tag/typescript%2Fv7.0.2) chỉ dẫn tới thông báo 7.0, không có changelog bản vá riêng. [Tag tại repository TypeScript](https://github.com/microsoft/TypeScript/releases/tag/v7.0.2) ngày 20/08 dẫn lại release gốc; đó không phải ngày phát hành npm lần đầu. Không suy ra danh sách “sửa lỗi riêng của .2” từ các tính năng major 7.

Theo [thông báo chính thức 7.0](https://devblogs.microsoft.com/typescript/announcing-typescript-7-0/): compiler được port sang **Go**, chạy native và xử lý song song; CLI stable vẫn là `tsc`. Benchmark của Microsoft đạt khoảng **8–12×** trên các codebase tham chiếu, không phải số đo của Baby Family. Watch được cải tiến; editor dùng LSP. Các cờ điều chỉnh song song như `--checkers`, `--builders`, `--singleThreaded` cần cân nhắc tài nguyên máy/CI, chưa cần tự tăng mặc định.

## Vì sao giữ hai compiler?

TypeScript 7.0 chưa cung cấp **Compiler API JavaScript ổn định tương thích TS6**. Thông báo 7.0 đặt API mới, khác API cũ, vào lộ trình 7.1; không có nghĩa tooling hiện tại tự tương thích khi đổi major. Các exports `unstable/*` trong [metadata npm 7.0.2](https://registry.npmjs.org/typescript/7.0.2) không thay thế API đang dùng.

[Hướng dẫn ts-jest chính thức](https://github.com/kulshekhar/ts-jest/blob/main/website/docs/guides/typescript-7.md) yêu cầu chạy song song qua alias; không ép peer dependency bằng `--legacy-peer-deps`, không đổi transformer sang compiler native. Trong repo này, generator cũng gọi `createSourceFile`; typed ESLint và `ts-node` cần API cũ.

| Dependency                                      | Vai trò                                                                                             |
| ----------------------------------------------- | --------------------------------------------------------------------------------------------------- |
| `@typescript/native: npm:typescript@7.0.2`      | Binary `tsc` native cho build/typecheck/watch.                                                      |
| `typescript: npm:@typescript/typescript6@6.0.2` | API `import ... from 'typescript'` cho Jest, ESLint, generator và seed. Binary đối chiếu là `tsc6`. |

`6.0.2` ở dòng thứ hai là **version của compatibility wrapper**; wrapper phụ thuộc `@typescript/old` từ nhánh `typescript@^6`. Phiên bản compiler API thực được khóa trong [package-lock.json](../package-lock.json), xem bằng `npx tsc6 --version`. Không thay wrapper thành `6.0.3` khi package đó không tồn tại. [Metadata compatibility package](https://registry.npmjs.org/@typescript%2ftypescript6).

Jest vẫn transform bằng API TS6; lợi ích native áp dụng cho build/typecheck, không tự làm Jest nhanh tương ứng. Diagnostics của Jest có thể khác compiler native; `npm run typecheck` là kiểm tra TypeScript chính thức của project. [Giải thích của ts-jest](https://github.com/kulshekhar/ts-jest/blob/main/website/docs/guides/typescript-7.md).

## Cấu hình và lệnh

[tsconfig.json](../tsconfig.json) dùng `NodeNext` cho module/resolution phù hợp Node; package hiện xuất CommonJS theo ngữ cảnh package, không chuyển app sang ESM chỉ vì đổi compiler. `rootDir`, `types`, strictness và decorators được khai báo tường minh. [tsconfig.build.json](../tsconfig.build.json) giới hạn source build.

`moduleResolution: node/node10` bị loại ở TS7; không dùng `ignoreDeprecations: "6.0"` để che cấu hình cũ. Những thay đổi mặc định như `types: []`, `rootDir: ./` và stable type ordering cần kiểm tra khi nâng. [Quy tắc chuyển đổi từ TS6](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-6-0.html). Dự án không cần ES5/AMD/UMD; khác biệt JavaScript/JSDoc được Microsoft ghi trong [CHANGES.md](https://github.com/microsoft/typescript-go/blob/main/CHANGES.md).

```bash
npx tsc --version            # Compiler native 7.0.2
npx tsc6 --version           # API/compiler compatibility TS6
npm run typecheck           # Native, không emit
npm run build               # Emit bằng native; không dùng compiler Nest CLI cũ
npm run start:dev           # Native watch + restart Node
npm run check               # Schema/generators/lint/type/build/unit/HTTP
```

Main build không đi qua Compiler API của Nest CLI. NestJS vẫn là framework runtime và giữ OOP/DI, DTO validation, decorator metadata. `ts-node` phục vụ seed dùng API compatibility; migration/seed giữ lệnh riêng như trước. Không dùng `typescript/unstable/*` để mô phỏng Compiler API cũ.

[tsconfig.test.json](../tsconfig.test.json) dành riêng cho transformer Jest dùng API TS6; `node10`/`ignoreDeprecations` chỉ tồn tại tại đây. Native typecheck vẫn kiểm cả source và tests bằng cấu hình chính `NodeNext`.

Prisma Client sinh mới theo NodeNext dùng import `.js` trong source `.ts`. Production chạy các file `.js` đã emit; Jest cần mapper cho import tương đối và seed cần `experimentalResolver` của `ts-node` trong [tsconfig.tools.json](../tsconfig.tools.json). [prisma.config.ts](../prisma.config.ts) chọn cấu hình này tường minh. Đã thêm regression chạy `ts-node` thật với `.js` specifier chỉ có file `.ts` tương ứng. Kiểm thử dùng client sinh mới và image Docker sạch để tránh kết quả sai từ client cũ.

## Kiểm chứng và số đo của repo

Phần dưới chỉ ghi kết quả thực chạy của lượt nâng cấp này; không dùng kết quả TS6 trước đó để kết luận TS7 đã đạt.

| Hạng mục                                   | Kết quả ngày 15/10/2026                                                                                                                                                                                               |
| ------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Native/compat version và dependency tree   | `tsc` 7.0.2, `tsc6`/API 6.0.3; `npm ls` không có invalid peer.                                                                                                                                                        |
| Typecheck/build và runtime JS đã emit      | PASS; full AppModule DI, ES256 JWT, DTO metadata/validation, Swagger, response projection và service scope qua `test:compiled`.                                                                                       |
| `npm run check` với Prisma Client sinh mới | PASS: format/lint/schema/DDL policy, persistence 369 files, service 236 files; 115 unit, 34 HTTP, 10 resource generator, 6 migration policy, 5 compiler compatibility, 7 runner tests và 1 compiled application test. |
| PostgreSQL integration                     | 17/17 PASS trên PostgreSQL 18.6 tmpfs, database riêng `_test`; replay 2 migrations và seed tách biệt.                                                                                                                 |
| Docker build và runtime                    | API/migrate images PASS; explicit migration/seed, readiness, Note create/read/soft delete PASS với DB kiểm thử; production image không chứa compiler.                                                                 |
| Native watch thực tế                       | PASS trên macOS arm64: code đổi thì restart, TS2322 giữ output và app đang chạy, initial error không chạy stale output; SIGTERM dọn toàn bộ child processes. Windows chưa chạy runtime.                               |

Đo trên **Apple M1 Max, macOS arm64, Node 26.11.1**, cùng `tsconfig.json`/source/tests và Prisma Client sinh mới. Mỗi compiler warmup 1 lần, sau đó chạy xen kẽ 3 lần; tính cả CLI startup, filesystem cache đã ấm, không chạy song song Docker build hoặc bộ test của lượt nâng cấp. Lệnh là `node_modules/.bin/tsc6 --noEmit --project tsconfig.json` và `node_modules/.bin/tsc --noEmit --project tsconfig.json`.

| Compiler | Ba lượt đo (giây)        | Median      |
| -------- | ------------------------ | ----------- |
| TS6.0.3  | 5,2054 / 4,7983 / 5,4551 | 5,2054 giây |
| TS7.0.2  | 1,2460 / 1,0759 / 1,0873 | 1,0873 giây |

**Typecheck local nhanh hơn khoảng 4,79×** trong phép đo này. Đây là mẫu nhỏ trên một máy, không phải SLA hay số đo cold build/CI/Jest/runtime API. Không dùng kết quả đo sơ bộ trước khi sinh lại Prisma Client làm kết quả cuối.

Review độc lập đã kiểm tra runner, cấu hình compiler, runtime metadata và resolver Prisma/seed. Container/network kiểm thử đã được dọn; không áp dụng migration/seed lên DB ứng dụng. `ts-node` hiện phát warning `DEP0180` trên Node26 khi chạy seed nhưng command hoàn tất thành công; theo dõi cùng các công cụ cần API TS6 khi hệ sinh thái nâng cấp. Nâng compiler không tự thay API nghiệp vụ hoặc tốc độ xử lý request.
