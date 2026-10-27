# Changelog

All notable changes to Oniel's Flat Theme are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the theme uses
[Semantic Versioning](https://semver.org/).

## [3.2.10] — 2026-10-27

### Fixed

- Every element inside the topic box sat on the card edge while the post text was
  inset — flush to the inline start, which is the right-hand side in an RTL forum
  (owner report: the text has a gap, the other elements and the buttons have
  none). Only the post row carried a gutter of its own, so the title, the topic
  map, the timeline column, the footer buttons and the suggested topics touched
  the card. The card now owns one inner gutter (`--mf-card-gutter`: 12px on a
  phone, 20px on a wide screen) and the post row carries none, so every child has
  the same edge and the reading inset is unchanged.
- The read count jumped while the window was resized and was missing entirely
  between md and 924px. Core builds the docked timeline from 925px up and renders
  the count in a bar under the reading column below that, but the theme's "empty
  chrome" rules were scoped to `from(md)` — so they suppressed the bar across the
  whole 768-924px range, where core has already stopped rendering the docked
  timeline, and the count only returned as a phone bar below 768px. Those rules
  now sit on core's own 925px breakpoint, and the bar keeps its gutter and its
  treatment across the entire `<=924px` range.
- The topic map (the view count) relied on auto-placement. Core renders it twice:
  `.topic-map.--op` inside the first post and `.topic-map.--bottom` with
  `grid-area: posts; grid-row: 2`. The theme's post row is a grid whose column 1
  is the 32px avatar column, so the map under the OP landed in that narrow cell
  and wrapped its stats into a stack (the old `avatar + gap` padding only pushed
  that wrapped content back under the text). It spans the row now, like the post
  notice. The bottom map's placement is explicit (`grid-column: 1; grid-row: 2`),
  so it stays under the reading column on both of core's grids instead of being
  auto-placed beside the sticky timeline.

### Notes

- Core's own transition at 925px stays: above it the count lives in the docked
  timeline column, below it in the bar under the reading column. That is core's
  timeline mode switch and the theme does not fight it; what changed is that the
  count no longer disappears at an intermediate width. No live check was possible
  here (no Discourse, no browser), so the reading is recorded in design log
  section 18-11 as inferred from core's CSS and JS.

## [3.2.9] — 2026-10-27

### Fixed

- On a narrow window the topic box lost its gutter on one side — the right-hand
  one in an RTL forum (owner report) — where the official theme holds a constant
  floor on both. The gap was written as `token - --d-wrap-padding-x`, so it
  depended on how much horizontal padding core's own `.wrap` rules contributed at
  that width: on this box core's padding lands on `#main-outlet-wrapper` and the
  subtraction replaced it, which left ~5px on a phone (10.7px `0.67em` taken off a
  16px token) and less as the window narrowed further. The theme now owns the
  gutter: core's two horizontal outlet tokens are zeroed on the wrapper — not on
  body, so the header and footer keep core's own gutter — and the full
  `--mf-topic-gutter` / `--mf-topic-gutter-end` are applied, giving each side its
  16px/24px floor at every width.
- The reading column stood on the box edge. Core gives the post body 12px of
  inline padding (`--topic-body-width-padding`) from its `sm` breakpoint up, and
  the theme's `padding: 4px 0 0` on `.cooked` removed it, so on a narrow window
  the text and the post controls touched the box. The post row now keeps a floored
  inline gutter (`--mf-post-gutter`: 12px on a phone, 17px at 1440px, capped at
  20px), so the avatar, the name row, the body, the post controls and the topic
  map share that one edge.
- The topic timeline was only styled in its docked column. In the modes core uses
  on a narrow window — full width under the reading column, pinned to the bottom
  of the page on a phone — the `1h` chip and the read count beside it walked onto
  the display edge. Every other timeline container, and the bar that carries the
  read count below `md`, now keep `--mf-timeline-gutter` (12px floor) as well.

### Notes

- Where core places the timeline and how it moves the read count between its own
  bar and the docked column is core's behaviour and was left untouched; the theme
  only guarantees each mode keeps a page gutter. The live check is recorded in the
  design log (section 18-10).

## [3.2.8] — 2026-10-27

### Fixed

- The save/revert tick and cross pair beside a changed setting was still not
  visible in the dark scheme. The 3.2.6 fix only reached buttons that are not
  `.btn-flat`, but core renders this pair without the `btn-default` prefix that
  its neighbour `btn-default undo setting-controls__undo` carries, so the pair
  can arrive as a flat button — and for a flat button the theme’s own
  `.btn-flat { border-color: transparent !important }` strips whatever edge the
  fill leaves. The pair is now matched on its own classes in every variant
  (including a bare `<button>`), with `.btn-flat` no longer excluded; transparent
  buttons, links, text buttons, the composer’s discard button and the whole
  `save-or-cancel` area still opt out, so nothing that is meant to read as a link
  gains a box.

### Changed

- The topic box now takes 8px more on its display side than on its sidebar side
  (`--mf-topic-gutter-end`): in an RTL forum that is the left-hand gap the owner
  asked to widen, and the logical property puts it on the right in an LTR forum.
- The topic box has the theme’s card corners (`--mf-radius-xl`, as on the topic
  list, the rails and the hero) instead of square ones. No `overflow: hidden` was
  added, because it would break the sticky topic timeline in the second grid
  column.

## [3.2.7] — 2026-10-27

### Fixed

- The topic box still stood too close to the display edge on one side — the left
  one in an RTL forum (owner report) and the right one in an LTR forum. 3.2.6
  added the same padding to both inline sides of `#main-outlet`, but the sidebar
  side of the box is already the grid gap, so that side came out ~13px wider than
  the display side: at a 1440px window the box stood 24px from the display edge
  and ~37px from the sidebar, which left the display side looking short. Every
  inline gap on a topic page — viewport ↔ sidebar, sidebar ↔ box, box ↔
  viewport — now reads one `--mf-topic-gutter` (`clamp(16px, 2.2vw, 40px)`): the
  sidebar's outer edge takes `padding-inline-start` on `#main-outlet-wrapper`, the
  display edge takes `padding-inline-end` on `#main-outlet`, and the sidebar gap
  keeps `--d-main-content-gap`. Both properties are logical, so an LTR forum
  mirrors the fix to its own display side without a second rule.

## [3.2.6] — 2026-10-27

### Fixed

- The save/revert pair that appears beside a changed admin setting (site settings
  and theme settings) was invisible in both schemes. Core renders it as two
  icon-only neutral buttons — `class="ok setting-controls__ok"` with
  `@icon="check"` and `class="cancel setting-controls__cancel"` with
  `@icon="xmark"` — and both classes sat in the `:not()` list that opts a button
  out of the neutral fill and the control line, so the pair fell through to the
  icon-only "no box" rule and stood on a transparent row with nothing to see.
  They now take the same fill, boundary and ink as every other default button;
  flat, transparent, link, text and discard variants still opt out, so nothing
  that is meant to read as a link gains a box.
- Text fields had no fill of their own in the dark scheme. The fill was
  `--mf-surface-2`, which measures #313131 against a #313131 `--mf-surface-2`
  card and #2f2f2f against a `--mf-surface-elevated` modal: a two-level
  difference, so a field inside a card or a dialog — including the repository
  URL field of *Install theme from a git repository* — read as the same colour
  as its surroundings. Fields now use a dedicated `--mf-field` token: the 9% tint
  in the light scheme (unchanged) and an inset #151515 in the dark one, darker
  than every surface. Core's newer design tokens
  `--token-color-background-input` / `--token-color-border-input`, which form-kit
  controls read instead of `--d-input-*`, are wired to the same values so a
  component core styles on its own follows the theme too.

### Changed

- The topic view is inset from the display edge by one standard gutter on both
  sides (12px on a phone, 24px on a wide screen) instead of core's
  `--d-wrap-padding-x` (0.67em ≈ 10.7px) on the outer side and a 32px sidebar gap
  on the other. The strip above the content box is smaller than the sides (8–12px)
  and the bottom is flush with the end of the page, matching the boxed layout of
  the official theme. Selector specificity stays below core's composer rule, so an
  open reply editor still reserves its height.

## [3.2.5] — 2026-10-25

### Changed

- The page wash is the owner's Concept A snippet verbatim: `body` paints
  `radial-gradient(ellipse at 12% 8%, var(--tertiary-very-low) …, transparent 44%)`
  and `radial-gradient(ellipse at 88% 78%, var(--primary-very-low) …, transparent 42%)`.
  The two variables it names are defined in the same block, because core ships
  no `--tertiary-very-low` at all — an undefined `var()` without a fallback
  invalidates the whole `background-image` — and its `--primary-very-low` is an
  opaque `#f8f8f8`. Both are translucent tints instead: 8% accent, 5% ink.
  Defining them on `body` also gives core what it expected: it reads
  `--tertiary-very-low` in 15 places but never defines it (14 of those
  declarations were dropped, e.g. date-picker focus, checked radio cards,
  private-message notices, `d-table` updated rows and badges, not-found search),
  and its `--primary-very-low` (71 references: keycaps, quote oneboxes, stat
  tiles, skeleton placeholders, loading sections, upload previews, emoji-picker
  hovers) is now a translucent 5% ink tint instead of an opaque `#f8f8f8`, so it
  reads in both schemes.
- The snippet's base colour stays `--mf-app-bg` instead of `--secondary`: in the
  light scheme `--secondary` and `--mf-surface` are both pure white, so the 3%
  step that separates the page from its cards would disappear.

## [3.2.4] — 2026-10-25

### Fixed

- Tag lists printed a comma between pills. Discourse renders the gap as a
  literal `.discourse-tags__tag-separator` span, so the pills read
  “شهیدی , جمع-عرفی , خویی” even though each tag is already its own box. The
  separator is now hidden in every tag list (topic list, topic header, profile),
  not just the ones this theme builds.
- Dividers had vanished across the site. Core draws more than 170 structural
  lines — topic body, post notice, topic map, modal and dialog header/footer,
  user menu, preferences rows, `hr`, admin tables — from
  `--content-border-color` and `--table-border-color`, and the theme had set
  both to `transparent`. Both now resolve to `--mf-hairline-strong`.
- Three edges the theme itself had erased were restored: the header's bottom
  line (header and page were one surface), modal header/footer rules, and
  sidebar section separators (`--d-sidebar-*-border-color` were transparent).
- Neutral `.btn` boxes were still invisible wherever a component used a plain
  `.btn` instead of `.btn-default`: `--d-button-border` was `none`, which core
  applies to every button. The token is a 1px control line again, so buttons
  from components and plugins (gamification, reactions, admin reports) get the
  same box; primary/danger/success fills and text-only `.btn-flat`,
  `.btn-transparent`, `.btn-link` explicitly opt out.
- Text fields, textareas and select-kit headers were borderless
  (`--d-input-border: none`), so a field on a panel of the same tone had no
  visible edge. They carry the control line and switch it to the accent on
  focus.

### Changed

- The control line is 55% ink instead of 45%: 3.35:1 on the light panel and
  3.84:1 on the dark panel, so a default button or field boundary clears the 3:1
  non-text contrast floor instead of approaching it.
- 3.2.3's padding compensation is gone: core reserves the 1px button border in
  the box, so buttons return to 8/14 padding and keep the size they had before
  3.2.3.
- The page background is a tinted wash instead of one flat colour: a very
  low-alpha accent glow at the reading start and an ink glow low at the far end,
  mirrored in RTL. Cards stay opaque, so only the gutters take the tint.
  (3.2.5 restates this as the owner's own snippet; see above.)

## [3.2.3] — 2026-10-24

### Fixed

- Neutral buttons had no visible box until hover. `buttons.scss` removed the
  border from every `.btn`, and a default button is filled with `--mf-panel` —
  the same fill as the card it sits on — so on a dark admin page the “check for
  updates” and “change source” buttons read as plain text. Inside cards and
  headers they now get a 1px control line (2.64:1 against the light panel,
  3.37:1 against the dark one) that strengthens to `--mf-ink-faint` on hover;
  padding loses the pixel the border gains so toolbars keep their height.
  Icon-only buttons stay borderless because the icon already identifies them.
- The online heading read as “کاربران آنلاین ۳”. The count now comes first in
  the markup, so a right-to-left reader gets «۳ کاربر آنلاین» and an LTR reader
  “3 online now”, and the Persian label is the singular noun a numeral needs.

### Changed

- The hero title now names this forum: «مباحثه، تالار علمی فقاهت».
- Persian strings use a plain ه where they used هٔ: «همه»، «درباره»، «تازه».
- The followers stat is labelled «دنبال‌کننده» so the number above it reads
  naturally.

## [3.2.2] — 2026-10-24

### Fixed

- Theme strings stayed English on a Persian site. The translations lived in
  `locales/fa.yml`, but Discourse resolves theme translations with
  `I18n.fallbacks[:fa_IR]`, which is `[:fa_IR, :en]`: the Persian file was never
  read, so every hero and rail label fell back to English while core stayed
  translated. The file is now `locales/fa_IR.yml`, keyed by `fa_IR`, as in
  Discourse's own themes.
- The hero subtitle stayed English even with Persian translations. The
  `hero_subtitle` setting shipped an English sentence as its default, which
  overrode the localized fallback line and would also survive in an install that
  had saved the setting once. The default is empty now, and the block treats the
  old sentence as "not set".
- The Persian copy was rewritten in a formal register for an academic forum —
  no colloquial openers, no transliterated jargon ("فلت", "خوراک"), and
  terminology aligned with core (`موضوعات`, `نوشته‌ها`, `پیوندها`).

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
