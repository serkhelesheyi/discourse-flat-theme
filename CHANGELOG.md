# Changelog

All notable changes to Oniel's Flat Theme are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the theme uses
[Semantic Versioning](https://semver.org/).

## [3.1.0] — 2026-10-22

Persian/RTL support, accessibility polish, and a leaner stylesheet.

### Added

- Persian translation (`locales/fa.yml`) aligned with `en`, `ru`, and `zh_CN`.
- Right-to-left layer (`stylesheets/app/rtl.scss`): mirrored affordance arrows, floats,
  and hover nudges, driven by `html[dir="rtl"]` only. Styling uses CSS logical
  properties, so the theme never sets `direction` itself.
- Persian font stack (`--mf-font-fa`), a `letter-spacing` reset for connected script, and
  a comfortable line height for Persian post bodies.
- "Quick links" rail section (`block-rail-links`), wired to the existing `rail_links`
  setting. Empty setting falls back to "All categories" and "About".
- Documentation set under `docs/`: theme docs, roadmap, repository audit, design log, and
  optimization log.

### Changed

- Contrast in both color schemes: text on accent, danger/success button labels, the muted
  text scale, and the focus ring now meet WCAG AA / 3:1 where they previously did not.
  The composer gained a visible keyboard focus ring.
- Radii: every corner now follows `ui_radius`; no hardcoded pixel radii remain.
- Motion: all durations come from `--mf-dur-*` and respect `prefers-reduced-motion`.
- The mobile header breakpoint uses the shared `viewport.until(md)` mixin.
- Rail and hero rows gained `:focus-visible` parity with `:hover`.
- Persian numbers in rail events and online counts use the core `dNumber` helper.

### Fixed

- `block-rail-links` markup and its RTL/motion selectors now match (`.block-rail-links__item`
  never existed), so mirrored arrows work when the section renders.
- Duplicated post separators and quoted-post resets were consolidated into `posts.scss`.

### Removed

- Dead `block-rail-stats` block and its stylesheet.
- Dead `.block-hero__chip` selectors, the unused `--shadow-focus-danger` token, and the
  unused `sliders` icon.
- No-op `create-topic-label` value transformer.
- Duplicate profile-header and profile-metadata rules in `overrides.scss`.
- Unused `assets/hero-background.png` (1.8 MB) and the archived `discourse-flat-theme.zip`
  (96 KB) from the repository root.
- 69 redundant `!important` declarations (3.8% of the total) with no cascade change.

## [3.0.0]

Initial public version: responsive Discourse theme with discovery hero, information rail,
Glimmer blocks, and native color-scheme based light/dark support.
