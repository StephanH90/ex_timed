// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require("tailwindcss/plugin");
const fs = require("fs");
const path = require("path");

// add opacity to any color by using color-mix
const colorMixOpacity = (color) =>
  `color-mix(in srgb, ${color} calc(100% * <alpha-value>), transparent)`;

const borderColor = colorMixOpacity("var(--border)");

module.exports = {
  content: [
    "../deps/ash_authentication_phoenix/**/*.*ex",
    "./js/**/*.js",
    "../lib/timed_web.ex",
    "../lib/timed_web/**/*.*ex",
  ],
  darkMode: "class",
  theme: {
    extend: {
      borderRadius: {
        DEFAULT: "var(--border-radius)",
      },
      fontFamily: {
        sans: ['"Source Sans 3"', "sans-serif"],
        mono: ["'Source Code Pro'", "monospace"],
      },
      keyframes: {
        loading: {
          "0%, 100%": { transform: "scale(0.1)", opacity: "1" },
          "50%": { transform: "scale(0.9)", opacity: "0" },
        },
      },
      fontSize: {
        "2xs": [
          "0.65rem",
          {
            lineHeight: "0.9rem",
          },
        ],
        "3xs": [
          "0.6rem",
          {
            lineHeight: "0.8rem",
          },
        ],
        "4xs": [
          "0.55rem",
          {
            lineHeight: "0.7rem",
          },
        ],
      },
      borderColor: {
        DEFAULT: borderColor,
      },
      colors: {
        background: {
          DEFAULT: "rgb(var(--background) / <alpha-value>)",
          muted: colorMixOpacity("var(--background-muted)"),
          secondary: "rgb(var(--background-secondary) / <alpha-value>)",
        },
        border: borderColor,
        danger: {
          DEFAULT: colorMixOpacity("var(--danger)"),
          accent: colorMixOpacity("var(--danger-accent)"),
          light: colorMixOpacity("var(--danger-light)"),
        },
        foreground: {
          DEFAULT: colorMixOpacity("var(--foreground)"),
          primary: "rgb(var(--foreground-primary) / <alpha-value>)",
          muted: "rgb(var(--foreground-muted) / <alpha-value>)",
          secondary: "rgb(var(--foreground-secondary) / <alpha-value>)",
          accent: colorMixOpacity("var(--foreground-accent)"),
        },
        primary: {
          DEFAULT: colorMixOpacity("var(--primary)"),
          dark: colorMixOpacity("var(--primary-dark)"),
          light: colorMixOpacity("var(--primary-light)"),
        },
        secondary: {
          DEFAULT: colorMixOpacity("var(--secondary)"),
          dark: colorMixOpacity("var(--secondary-dark)"),
          light: colorMixOpacity("var(--secondary-light)"),
        },
        tertiary: {
          DEFAULT: colorMixOpacity("var(--tertiary)"),
          dark: colorMixOpacity("var(--tertiary-dark)"),
          light: colorMixOpacity("var(--tertiary-light)"),
        },
        success: {
          DEFAULT: colorMixOpacity("var(--success)"),
          accent: colorMixOpacity("var(--success-accent)"),
          light: colorMixOpacity("var(--success-light)"),
        },
        warning: {
          DEFAULT: colorMixOpacity("var(--warning)"),
          accent: colorMixOpacity("var(--warning-accent)"),
          light: colorMixOpacity("var(--warning-light)"),
        },
        white: "rgb(var(--white) / <alpha-value>)",
        black: "rgb(var(--black) / <alpha-value>)",
        overview: {
          workday: {
            DEFAULT: colorMixOpacity("var(--overview-workday)"),
            active: colorMixOpacity("var(--overview-workday-active)"),
            hf: colorMixOpacity("var(--overview-workday-hf)"),
          },
          absence: {
            DEFAULT: colorMixOpacity("var(--overview-absence)"),
            active: colorMixOpacity("var(--overview-absence-active)"),
            hf: colorMixOpacity("var(--overview-absence-hf)"),
          },
          weekend: {
            DEFAULT: colorMixOpacity("var(--overview-weekend)"),
            active: colorMixOpacity("var(--overview-weekend-active)"),
            hf: colorMixOpacity("var(--overview-weekend-hf)"),
          },
          active: colorMixOpacity("var(--overview-active)"),
          hf: colorMixOpacity("var(--overview-hf)"),
        },

        // override border colour used by @tailwindcss/forms
        gray: {
          500: borderColor,
        },
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    // Allows prefixing tailwind classes with LiveView classes to add rules
    // only when LiveView classes are applied, for example:
    //
    //     <div class="phx-click-loading:animate-ping">
    //
    plugin(({ addVariant }) =>
      addVariant("phx-click-loading", [
        ".phx-click-loading&",
        ".phx-click-loading &",
      ])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-submit-loading", [
        ".phx-submit-loading&",
        ".phx-submit-loading &",
      ])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-change-loading", [
        ".phx-change-loading&",
        ".phx-change-loading &",
      ])
    ),

    // Embeds Heroicons (https://heroicons.com) into your app.css bundle
    // See your `CoreComponents.icon/1` for more information.
    //
    plugin(function ({ matchComponents, theme }) {
      let iconsDir = path.join(__dirname, "../deps/heroicons/optimized");
      let values = {};
      let icons = [
        ["", "/24/outline"],
        ["-solid", "/24/solid"],
        ["-mini", "/20/solid"],
        ["-micro", "/16/solid"],
      ];
      icons.forEach(([suffix, dir]) => {
        fs.readdirSync(path.join(iconsDir, dir)).forEach((file) => {
          let name = path.basename(file, ".svg") + suffix;
          values[name] = { name, fullPath: path.join(iconsDir, dir, file) };
        });
      });
      matchComponents(
        {
          hero: ({ name, fullPath }) => {
            let content = fs
              .readFileSync(fullPath)
              .toString()
              .replace(/\r?\n|\r/g, "");
            let size = theme("spacing.6");
            if (name.endsWith("-mini")) {
              size = theme("spacing.5");
            } else if (name.endsWith("-micro")) {
              size = theme("spacing.4");
            }
            return {
              [`--hero-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
              "-webkit-mask": `var(--hero-${name})`,
              mask: `var(--hero-${name})`,
              "mask-repeat": "no-repeat",
              "background-color": "currentColor",
              "vertical-align": "middle",
              display: "inline-block",
              width: size,
              height: size,
            };
          },
        },
        { values }
      );
    }),
  ],
};
