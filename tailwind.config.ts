import type { Config } from "tailwindcss";

export default {
  content: ["./index.html", "./src/**/*.{ts,tsx,js,jsx}"],
  theme: {
    extend: {
      backgroundImage: {
        'survey-gradient': 'linear-gradient(135deg, hsl(25, 100%, 95%) 0%, hsl(25, 85%, 85%) 100%)',
      },
    },
  },
  plugins: [],
} satisfies Config;
