module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/assets/stylesheets/**/*.css',
  ],
  theme: {
    extend: {
      colors: {
        border: "hsl(214.3 31.8% 88%)", // Slightly darker zinc-200
        input: "hsl(214.3 31.8% 88%)", // Slightly darker zinc-200
        ring: "hsl(30 85% 31%)", // Dark amber
        background: "hsl(220 10% 95%)", // Very light grey
        foreground: "hsl(222.2 47.4% 11.2%)", // zinc-900
        primary: {
          DEFAULT: "hsl(30 85% 31%)", // Dark amber
          foreground: "hsl(0 0% 100%)", // white
        },
        secondary: {
          DEFAULT: "hsl(210 80% 70%)", // A light, vibrant blue (e.g., sky-300 equivalent)
          foreground: "hsl(222.2 47.4% 11.2%)", // zinc-900
        },
        destructive: {
          DEFAULT: "hsl(0 84.2% 60.2%)", // red-500 (#e74c3c)
          foreground: "hsl(0 0% 100%)", // white
        },
        muted: {
          DEFAULT: "hsl(210 20% 92%)", // A slightly darker, more distinct light grey
          foreground: "hsl(215.4 16.3% 46.9%)", // zinc-500
        },
        accent: {
          DEFAULT: "hsl(158 70.8% 36.5%)", // emerald-700 (#16a085)
          foreground: "hsl(0 0% 100%)", // white
        },
        popover: {
          DEFAULT: "hsl(0 0% 100%)", // white
          foreground: "hsl(222.2 47.4% 11.2%)", // zinc-900
        },
        card: {
          DEFAULT: "hsl(0 0% 100%)", // white
          foreground: "hsl(222.2 47.4% 11.2%)", // zinc-900
        },
      },
      fontFamily: {
        sans: ['ui-sans-serif', 'system-ui', 'sans-serif'],
        poppins: ['Poppins', 'sans-serif'], // For logo
      },
    },
  },
  plugins: [],
}