import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  server: {
    host: true,  // This allows external access
    port: 5173,
    strictPort: true, // Ensures the port doesn't change if unavailable
  },
  plugins: [react()],
})
