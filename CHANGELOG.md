# Changelog

All notable changes to Oniel's Flat Theme are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the theme uses
[Semantic Versioning](https://semver.org/).

## [3.2.1] — 2026-10-24

### Fixed

- The theme failed to load after 3.2.0 (`Attempted to resolve a component or
  helper in a strict mode template, but that value was not in scope: i18n`).
  `block-rail-events.gjs` traded `import { i18n }` for the default `I18n` import
  while its template still rendered `{{i18n ...}}`, and a `.gjs` template is
  compiled in strict mode, so every identifier it uses must be imported. The
  block now imports both (`import I18n, { i18n } from "discourse-i18n"`), and all
  nine theme templates were compiled in strict mode to confirm nothing else is
  missing from scope.

## [3.2.0] — 2026-10-24

### Changed

- Rail events show the calendar month name in the reader's language instead of a
  month number plus a suffix: `Oct / 24` in English, `اکتبر / ۲۴` under `fa_IR`,
  `окт. / 24` in Russian, `10月 / 24` in Chinese. Both lines come from one
  `Intl.DateTimeFormat` built on the BCP47 locale core already exposes, so the
  theme stores no month strings. The calendar stays Gregorian, as Discourse
  renders every other date, so the event day never disagrees with the post
  timestamps next to it; only the names and digits follow the locale.
- The date badge grows with the month name (40px minimum) instead of clipping a
  long name inside a fixed 40px box.

### Removed

- `rail.month_suffix` from all four locales. It only made sense while the month
  was a bare number, and in Persian it read as "۱۰ ماه".

## [3.1.5] — 2026-10-24

### Fixed

- Mobile filter menu: the bottom sheet is back, and the flash that made it look
  like it closed and re-opened is gone. The theme animated every
  `.d-modal__container`, and core adds then removes `is-entering` on that same
  element; when the class left, the container's animation changed and the
  browser restarted it, so the sheet faded out and in again right after it slid
  up. Modal motion is core's job now — the theme no longer animates modal
  containers or backdrops — and these sheets opt out of motion entirely, so they
  appear on the tap instead of re-entering under the finger.
- Mobile filter sheet styling: flat elevated surface with only the top corners
  rounded, 48px rows with the active filter carried by the accent tint, 8px body
  padding and safe-area inset, no separators, shadows or backdrop blur.
- Mobile filter button: with the sheet restored, `#navigation-bar` holds a
  single trigger again, so it keeps its natural width beside the new-topic
  button instead of taking a full-width row of its own.

## [3.1.4] — 2026-10-24

### Fixed

- Mobile topic list: categories and tags stay on one line that scrolls
  sideways, instead of wrapping onto a second row and making rows different
  heights. The same line is used on suggested topics.
- Mobile filter menu: the "latest" button no longer opens the core bottom sheet,
  which flashed and re-opened on touch screens. The filters are inline pills in a
  single horizontally scrollable row, one tap away, through the
  `navigation-bar-dropdown-mode` transformer.
- Bottom-sheet menus: the animation opt-out never matched, because float-kit puts
  `fk-d-menu-modal` on the modal wrapper rather than on its container. Other
  sheets (reaction and user lists) no longer animate over core's own slide.

## [3.1.3] — 2026-10-23

### Fixed

- The header search icon no longer blinks on the first load of a discovery page.
  Hiding the core welcome banner with CSS still mounted it, and its viewport
  modifier marked the banner search as visible for one frame, which removed the
  header icon. The banner is now not rendered at all through the
  `welcome-banner-display-for-route` transformer, with the CSS rule kept as a
  fallback for older builds.

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
