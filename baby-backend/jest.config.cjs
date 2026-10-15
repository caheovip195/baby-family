module.exports = {
  rootDir: '.',
  testEnvironment: 'node',
  testMatch: ['<rootDir>/test/unit/**/*.spec.ts'],
  // ts-jest uses the official TypeScript 6 API compatibility alias.
  // Native TypeScript 7 independently checks all source/tests via npm run typecheck.
  transform: {
    '^.+\\.ts$': [
      'ts-jest',
      { compiler: 'typescript', tsconfig: 'tsconfig.test.json' },
    ],
  },
  // Prisma uses NodeNext-style .js specifiers after fresh generation. Tests
  // execute TypeScript source while production executes the emitted JS files.
  moduleNameMapper: { '^(\\.{1,2}/.*)\\.js$': '$1' },
  collectCoverageFrom: [
    'src/**/*.ts',
    '!src/generated/**',
    '!src/main.ts',
    '!src/**/*.module.ts',
    '!src/**/dto/**',
  ],
  coverageDirectory: 'coverage',
  clearMocks: true,
  setupFiles: ['<rootDir>/test/setup-env.ts'],
};
