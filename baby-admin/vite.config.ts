/// <reference types="vitest" />
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

// Admin CMS (tech spec §24): internal tool, served behind VPN/IP allowlist.
// In development `/admin/v1` is proxied to the backend so no CORS is opened.
export default defineConfig({
  plugins: [react()],
  server: {
    port: 5174,
    proxy: {
      '/admin/v1': process.env.ADMIN_API_URL ?? 'http://localhost:3000',
    },
  },
  test: {
    environment: 'jsdom',
    globals: true,
    setupFiles: ['./src/test-setup.ts'],
  },
});
