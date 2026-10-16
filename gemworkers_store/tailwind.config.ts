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
          base:       '#FBF8F3',
          surface:    '#FFFFFF',
          raised:     '#F4EEE4',
          border:     '#ECE5D8',
          gold:       '#7A5A22',
          'gold-dim': '#B89A63',
          primary:    '#1F1B16',
          secondary:  '#5A5045',
          muted:      '#6B6052',
        },
      },
      fontFamily: {
        serif: ['var(--font-cormorant)', 'Georgia', "'Times New Roman'", 'serif'],
        sans:  ['var(--font-inter)', 'system-ui', 'sans-serif'],
      },
      typography: {
        vault: {
          css: {
            '--tw-prose-body':          '#1F1B16',
            '--tw-prose-headings':      '#1F1B16',
            '--tw-prose-lead':          '#5A5045',
            '--tw-prose-links':         '#7A5A22',
            '--tw-prose-bold':          '#1F1B16',
            '--tw-prose-counters':      '#B89A63',
            '--tw-prose-bullets':       '#B89A63',
            '--tw-prose-hr':            '#ECE5D8',
            '--tw-prose-quotes':        '#1F1B16',
            '--tw-prose-quote-borders': '#ECE5D8',
            '--tw-prose-captions':      '#5A5045',
            '--tw-prose-code':          '#1F1B16',
            '--tw-prose-pre-code':      '#1F1B16',
            '--tw-prose-pre-bg':        '#FFFFFF',
            '--tw-prose-th-borders':    '#ECE5D8',
            '--tw-prose-td-borders':    '#ECE5D8',
            'h1, h2, h3, h4, h5, h6': {
              fontFamily: "var(--font-cormorant, Georgia, 'Times New Roman', serif)",
              fontWeight: '400',
              letterSpacing: '0.02em',
            },
            a: {
              color: '#7A5A22',
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
