module.exports = {
  ...require('./jest.config.cjs'),
  testMatch: ['<rootDir>/test/integration/**/*.spec.ts'],
  testTimeout: 30000,
  // Specs share one database, so they run one file at a time (`--maxWorkers=1`).
  // Each spec boots a Nest app (~1.3 GB RSS); a single in-band process keeps
  // growing across files, so the worker is recycled once it passes this limit.
  workerIdleMemoryLimit: '1536MB',
};
