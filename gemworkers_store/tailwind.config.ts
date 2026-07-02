import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        vault: {
          base:       '#0e0e10',
          surface:    '#16161a',
          raised:     '#1e1e24',
          border:     '#2a2a30',
          gold:       '#c9a962',
          'gold-dim': '#7a6234',
          primary:    '#f5f0e8',
          secondary:  '#9d9080',
          muted:      '#4a4440',
        },
      },
      fontFamily: {
        serif: ['var(--font-cormorant)', 'Georgia', "'Times New Roman'", 'serif'],
        sans:  ['var(--font-inter)', 'system-ui', 'sans-serif'],
      },
    },
  },
  plugins: [],
};

export default config;
