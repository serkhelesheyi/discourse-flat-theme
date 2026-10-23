# Changelog

All notable changes to Oniel's Flat Theme are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the theme uses
[Semantic Versioning](https://semver.org/).

## [3.1.2] — 2026-10-23

Follow-up fixes from testing 3.1.1 on a forum running the composer redesign.

### Fixed

- Search: focusing a search field no longer draws a second, inner focus ring. The
  wrapper keeps the single ring the theme intends.
- New-topic composer: the title's focus ring keeps its full weight next to the
  picker bar, which used to paint over its top edge.
- Mobile composer: the editor that slides up over the title on focus is now opaque
  and keeps its own slide shadow, so the title can no longer show through the
  editor and its placeholder.
- Mobile filter menu: also remove the modal entrance animation, not just the
  popover one, which was the remaining source of the jump when it opened.

## [3.1.1] — 2026-10-23

Fixes from the first live test on a production forum.

### Fixed

- New-topic composer: the title field is pinned to the first row, with the category
  and tag pickers on the row below. The gap between the rows stops the picker
  background from painting over the title's focus ring.
- Topic lists show a hairline between rows again, instead of relying on the hover
  fill alone to mark where a topic ends.
- Header: avatar, private messages, search and the colour-scheme toggle are centred
  on one line instead of hanging at different heights.
- Topic pages widen the reading measure to `clamp(700px, 54vw, 800px)` above 1200px,
  so a topic keeps the narrow discovery column only on discovery pages.
- Mobile composer: the title and picker rows keep their height when the editor takes
  focus, so the editor can no longer overlap the title.
- Mobile topic list: long categories and tags wrap instead of being cut mid-word.
- Mobile "latest" filter menu: removed the popover entrance animation that made the
  floating menu jump and blink when it opened.

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
