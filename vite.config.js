import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// https://vite.dev/config/
export default defineConfig({
//base: '/cos30043/s104480538/project/' , // Set the base path for the project
base: '/cos30043-2-/', //for github lives
//base: '/',
plugins: [vue()],
})
