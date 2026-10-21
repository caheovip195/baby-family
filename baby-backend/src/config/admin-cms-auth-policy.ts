/** Authentication protocol policy; changing values does not extend existing sessions. */
export const ADMIN_CMS_AUTH_POLICY = Object.freeze({
  version: 1,
  sessionTtlMs: 15 * 60 * 1000,
  loginWindowMs: 15 * 60 * 1000,
  identityAttemptsPerWindow: 5,
  clientAttemptsPerWindow: 20,
});
