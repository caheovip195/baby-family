import js from '@eslint/js';
import globals from 'globals';
import tseslint from 'typescript-eslint';

export default tseslint.config(
  { ignores: ['dist/**', 'coverage/**', 'src/generated/**'] },
  js.configs.recommended,
  ...tseslint.configs.recommendedTypeChecked,
  {
    files: ['**/*.mjs'],
    extends: [tseslint.configs.disableTypeChecked],
    languageOptions: { globals: globals.node },
  },
  {
    files: ['**/*.ts'],
    languageOptions: {
      globals: { ...globals.node, ...globals.jest },
      parserOptions: {
        project: './tsconfig.json',
        tsconfigRootDir: import.meta.dirname,
      },
    },
    rules: {
      '@typescript-eslint/no-explicit-any': 'error',
      '@typescript-eslint/no-floating-promises': 'error',
      '@typescript-eslint/consistent-type-imports': [
        'error',
        { prefer: 'type-imports', disallowTypeAnnotations: false },
      ],
      '@typescript-eslint/no-unused-vars': [
        'error',
        { argsIgnorePattern: '^_' },
      ],
    },
  },
  {
    files: ['**/*.spec.ts', 'test/**/*.ts'],
    rules: {
      '@typescript-eslint/unbound-method': 'off',
      '@typescript-eslint/no-unsafe-assignment': 'off',
    },
  },
  {
    files: ['src/services/**/*.ts', 'src/interfaces/**/*.ts'],
    rules: {
      'no-restricted-imports': [
        'error',
        {
          patterns: [
            {
              group: [
                '@prisma/*',
                '**/generated/**',
                '**/database/**',
                '**/repositories/*.repository*',
                '**/services/*.service*',
                '**/controllers/**',
              ],
              message:
                'Services use repository interfaces; concrete persistence belongs in repositories.',
            },
          ],
        },
      ],
    },
  },
  {
    files: ['src/controllers/**/*.ts'],
    ignores: ['src/controllers/health.controller.ts'],
    rules: {
      'no-restricted-imports': [
        'error',
        {
          patterns: [
            {
              group: [
                '@prisma/*',
                '**/generated/**',
                '**/database/**',
                '**/repositories/**',
                '**/interfaces/repositories/**',
                '**/services/*.service*',
              ],
              message:
                'Controllers use service interfaces; business rules belong in services.',
            },
          ],
        },
      ],
    },
  },
  {
    files: ['src/models/**/*.ts'],
    rules: {
      'no-restricted-imports': [
        'error',
        {
          patterns: [
            {
              group: [
                '@nestjs/*',
                '@prisma/*',
                '**/generated/**',
                '**/database/**',
                '**/repositories/**',
                '**/services/**',
                '**/controllers/**',
                '**/dto/**',
              ],
              message:
                'Models contain table attributes and instance helpers, without persistence or business orchestration.',
            },
          ],
        },
      ],
    },
  },
  {
    files: ['src/repositories/**/*.ts'],
    rules: {
      'no-restricted-imports': [
        'error',
        {
          patterns: [
            {
              group: ['**/services/*.service*', '**/controllers/**'],
              message:
                'Repositories own database operations and model mapping; they do not call services or controllers.',
            },
          ],
        },
      ],
    },
  },
);
