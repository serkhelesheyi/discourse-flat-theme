# Oniel's Flat Theme

A modern, responsive, full Discourse theme focused on clarity, density, and consistent interaction patterns. It provides a calm flat visual system for desktop, Android, and iOS layouts without decorative gradients, glass effects, or unnecessary separators.

## Features

- Responsive topic lists, categories, topic pages, profiles, groups, badges, notifications, composer, authentication, and administration screens.
- Compact discovery hero with search and popular category shortcuts.
- Optional information rail with upcoming events, hot topics, contributors, popular tags, quick links, and online users.
- Shared design tokens and reusable control primitives for tabs, fields, buttons, dialogs, and status banners.
- Light and dark color schemes based on native Discourse color variables.
- Accessible focus states, reduced-motion support, touch-friendly controls, and mobile-specific layout fixes.
- Persian (`fa_IR`) support: right-to-left layout, a Persian font stack, and Persian typography rules.
- English, Persian, Russian, and Simplified Chinese translations.

## Installation

In Discourse, open **Admin → Customize → Themes**, select **Install**, and use:

```text
https://github.com/0niel/discourse-flat-theme
```

The theme can also be installed or updated with the official [`discourse_theme`](https://meta.discourse.org/t/install-the-discourse-theme-cli-console-app-to-help-you-build-themes/82950) CLI.

## Theme settings

| Setting               | Description                                                                   |
| --------------------- | ----------------------------------------------------------------------------- |
| `show_hero`           | Shows the compact discovery hero.                                             |
| `show_info_rail`      | Shows the information rail on wide layouts.                                   |
| `rail_links`          | Quick links in the rail. Each entry has a `label` and a `url`; empty means the default “All categories” / “About” links. |
| `rail_leaderboard_id` | Gamification leaderboard ID used by the contributors rail.                    |
| `hero_subtitle`       | Overrides the hero subtitle.                                                  |
| `show_topic_excerpts` | Shows a short excerpt under each topic title in topic lists.                  |
| `accent_color`        | Overrides the theme accent color (any CSS color, e.g. `#2563eb`).             |
| `content_max_width`   | Controls the maximum content width, in pixels.                                |
| `ui_radius`           | Scales interface corner radii (`1` = default, `0` = square, `2` = very round). |

## Persian and RTL support

The theme ships `locales/fa.yml` and does not rely on core's automatic mirroring: Discourse mirrors only its own stylesheets, so the theme is written with CSS logical properties (`margin-inline`, `padding-block`, `inset-inline-*`, `border-inline-*`, `text-align: start/end`). The remainder that logical properties cannot express — mirrored arrow glyphs, floats, and hover nudges — lives in `stylesheets/app/rtl.scss` behind `html[dir="rtl"]`. The theme never sets `direction` itself.

Persian typography is handled by a system font stack (`--mf-font-fa`), a `letter-spacing` reset for connected script, and a more generous line height for post bodies. Numbers and dates stay with Discourse's own i18n helpers, so `fa_IR` renders Persian digits without hardcoded values.

To check it, switch your user or site locale to `fa_IR` and review `/latest`, a category, a topic, the composer, a profile, and search.

## Development

Requirements:

- Node.js 22 or newer
- pnpm 10
- A current installation of `discourse_theme`

```bash
pnpm install --frozen-lockfile
pnpm lint
discourse_theme watch .
```

To upload the theme to a configured Discourse instance:

```bash
discourse_theme upload .
```

Discourse API credentials must remain in the local `~/.discourse_theme` credential store and must never be committed.

## Project structure

```text
about.json
settings.yml
common/common.scss
mobile/mobile.scss
stylesheets/brand/      design tokens (colors, type, spacing, radii, motion)
stylesheets/app/        core-surface styles, one file per area
stylesheets/blocks/     styles for each theme block
stylesheets/lib/        structural helpers (containers.scss)
javascripts/discourse/api-initializers/   outlets, transformers, initializers
javascripts/discourse/blocks/             Glimmer UI blocks (hero, rail sections)
locales/                en, fa, ru, zh_CN
```

`common/common.scss` is the primary entry point. Responsive behavior that depends on viewport width belongs in the common stylesheets. `mobile/mobile.scss` is reserved for differences in Discourse's mobile-specific DOM.

All colors come from Discourse color-scheme custom properties (`--primary`, `--secondary`, `--tertiary`, …) through the `--mf-*` tokens in `stylesheets/brand/tokens.scss`; both light and dark schemes are derived with `light-dark()` and `color-mix()` instead of fixed values. Theme-owned classes never need `!important`, and core overrides are kept as small and as specific as possible.

## Validation

Before publishing a change:

1. Run `pnpm install --frozen-lockfile` and `pnpm lint`.
2. Preview `/latest`, `/categories`, a category, and a topic.
3. Test desktop and mobile layouts in both light and dark color schemes.
4. Test with an RTL locale (`fa_IR`) as well as an LTR locale.
5. Test anonymous and authenticated states, keyboard navigation, and reduced motion.
6. Check the browser console and verify the `/safe-mode` fallback.

GitHub Actions uses Discourse's official reusable theme workflow.

## Documentation

The `docs/` folder holds the project's working memory (written in Persian):

| File | Contents |
| --- | --- |
| `01-discourse-theme-docs.fa.md` | Digest of the official Discourse theme documentation and deprecations. |
| `02-roadmap.fa.md` | Phase plan, current status, session notes, open questions and rules. Start here. |
| `03-repo-audit.fa.md` | Repository audit (styles, JS, blocks, locales) and its corrections. |
| `04-design-log.fa.md` | Contrast, typography, focus and motion decisions with measurements. |
| `05-optimization-log.fa.md` | Stylesheet size, `!important` and dead-code metrics. |
| `06-live-test-plan.fa.md` | Live-test matrix, page checklists and how to close the final phase. |
| `07-jalali-calendar-report.fa.md` | Feasibility report on showing forum dates in the Persian (Jalali) calendar. |

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for the changes in each release.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for the development and pull request workflow. Security reports should follow [SECURITY.md](SECURITY.md).

## License

[MIT](LICENSE)
