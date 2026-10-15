import type { Config } from "tailwindcss";
import typography from "@tailwindcss/typography";

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
      typography: {
        vault: {
          css: {
            '--tw-prose-body':          '#f5f0e8',
            '--tw-prose-headings':      '#f5f0e8',
            '--tw-prose-lead':          '#9d9080',
            '--tw-prose-links':         '#c9a962',
            '--tw-prose-bold':          '#f5f0e8',
            '--tw-prose-counters':      '#7a6234',
            '--tw-prose-bullets':       '#7a6234',
            '--tw-prose-hr':            '#2a2a30',
            '--tw-prose-quotes':        '#f5f0e8',
            '--tw-prose-quote-borders': '#2a2a30',
            '--tw-prose-captions':      '#9d9080',
            '--tw-prose-code':          '#f5f0e8',
            '--tw-prose-pre-code':      '#f5f0e8',
            '--tw-prose-pre-bg':        '#16161a',
            '--tw-prose-th-borders':    '#2a2a30',
            '--tw-prose-td-borders':    '#2a2a30',
            'h1, h2, h3, h4, h5, h6': {
              fontFamily: "var(--font-cormorant, Georgia, 'Times New Roman', serif)",
              fontWeight: '400',
              letterSpacing: '0.02em',
            },
            a: {
              color: '#c9a962',
              textDecoration: 'none',
              '&:hover': { textDecoration: 'underline' },
            },
          },
        },
      },
    },
  },
  plugins: [typography],
};

export default config;
