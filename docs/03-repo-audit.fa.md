# ۳. گزارش بازبینی کامل ریپو — فاز ۲ (تاریخ: ۲۰۲۶-۱۰-۲۰)

> **کاربری این سند:** خروجی فاز ۲ نقشه راه. فازهای ۳ (RTL/فارسی)، ۴ (طراحی) و ۵ (بهینه‌سازی) باید از ستون «فاز هدف/الویت» همین گزارش ادامه یابند. **در فاز ۲ کد تغییر نکرده است؛ این سند فقط یافته‌ها را ثبت می‌کند.**
>
> بخش «۹) پیوست فاز ۳» در پایان سند، پیشرفت واقعی فاز ۳ را ثبت می‌کند.

---

## ۱) خلاصهٔ اجرایی

| موضوع | وضعیت | ارزیابی |
|---|---|---|
| معماری ریپو | تم Full با سیستم توکن اختصاصی `--mf-*` + بلوک‌های Glimmer | سالم و مدرن؛ وابسته به APIهای جدید (`renderBlocks`، value transformerها، `light-dark()`) |
| Lint | `pnpm lint` ناموفق (کد ۱) | ۵ خطای stylelint + ۱۰ فایل نیازمند format در prettier؛ همه با `--fix`/`-w` قابل‌رفع |
| Types (`ember-tsc`) | موفق (کد ۰) | — |
| `!important` | ۱۷۹۵ مورد | نقطهٔ ضعف اصلی فاز ۵ |
| رنگ‌ها | مطابق قانون مستندات (`light-dark()` + `color-mix` از متغیرهای scheme) | تقریباً بی‌نقص؛ چند هاردکد جزئی |
| Deprecations | هیچ `.hbs` / widget API / inline script وجود ندارد | هم‌راستا با سیاست‌های ۲۰۲۴–۲۰۲۶ |
| RTL/فارسی | هیچ: بدون locale فارسی، بدون استایل RTL، فونت فارسی تنظیم نشده | دامنهٔ کامل کار فاز ۳ |
| زبالهٔ ریپو | `discourse-flat-theme.zip` (~۹۶KB) در گیت؛ `assets/hero-background.png` ثبت‌شده اما استفاده‌نشده | حذف در فاز ۵ |

---

## ۲) محیط و خروجی پایه

- `pnpm install --frozen-lockfile` → موفق (۵.۵ ثانیه، pnpm 10.28).
- `pnpm lint:types` (`ember-tsc -b`) → موفق، کد ۰.
- `pnpm lint` → ناموفق، کد ۱؛ شکست‌ها فقط در دو لینتر:
  - **stylelint (۵ خطا):** `selector-not-notation` در `mobile-platform.scss:95`؛ `scss/double-slash-comment-empty-line-before` در `leaderboard.scss:29`، `surfaces.scss:191` و `209`، `topic-list.scss:196` (همه با `--fix` رفع می‌شوند).
  - **prettier (۱۰ فایل):** `controls`, `overrides`, `posts`, `profile`, `topic-list`, `topic`, `mobile-platform` (scss) + `block-hero`, `block-rail-events`, `block-rail-profile` (gjs).
  - eslint و ember-template-lint سبز (۱۶ فایل: ۳ js + ۱۳ gjs).
- طبق قاعدهٔ فاز ۲، اصلاح نشد؛ رفع با `pnpm lint:fix` در ابتدای فاز ۳ یا فاز ۵ انجام شود.

---

## ۳) استایل — شمارش و ریسک‌ها

### `!important` به تفکیک فایل (۱۵ مورد اول؛ مجموع ۱۷۹۵)

| فایل | تعداد |
|---|---|
| app/overrides.scss | ۳۳۱ |
| app/profile.scss | ۱۹۶ |
| app/topic.scss | ۱۴۵ |
| app/topic-list.scss | ۱۳۵ |
| app/controls.scss | ۱۲۱ |
| mobile-platform.scss | ۱۱۷ |
| app/surfaces.scss | ۷۶ |
| app/docs.scss | ۶۹ |
| app/embedded-replies.scss | ۶۵ |
| app/groups.scss | ۶۳ |
| app/calendar.scss | ۶۳ |
| app/posts.scss | ۴۹ |
| app/composer.scss | ۴۰ |
| app/auth.scss | ۳۸ |
| app/sidebar.scss | ۳۰ |

خروج فاز ۵ باید با گزارش کاهش قبل/بعد همراه باشد.

### z-index (در مجموع فقط ۱۰ مورد → سالم)

مقادیر: `1`, `2`, `3`, `30`, `20` (×۳)، `40 !important` (×۳). مورد‌های 40 با important معمولاً مربوط به dropdown/header ها هستند؛ در فاز ۵ جایگزینی با توکن بررسی شود.

### انتخابگرهای سطح بالا (html/body)

همه هدفمند و مشروط‌اند (`html.mobile-view`، `body.welcome-banner--visible ...`، `body.navigation-filter ...`، `html.desktop-view .more-topics__container` و ...)؛ بازنویسی سراسری بدون شرط وجود ندارد. سالم.

---

## ۴) رنگ‌ها، فونت و حالت تاریک

### `stylesheets/brand/tokens.scss` — انطباق عالی با مستندات

- تقریباً همهٔ توکن‌های رنگ از متغیرهای scheme مشتق‌اند: `--mf-ink: var(--primary)`، `--mf-accent: var(--tertiary)`، `--mf-success/danger/love: var(--...)` و ترکیب‌های `color-mix(in srgb, ...)` روی آن‌ها.
- سطوح (`--mf-surface*`، `--mf-app-bg`، `--mf-fill-*`، `--mf-hairline*`) با `light-dark()` تعریف شده‌اند؛ یعنی پشتیبانی dark mode خودکار بدون کد اضافی. پوشش حالت تاریک سالم ارزیابی می‌شود.
- دو استثنای کوچک: `--mf-accent-fg: #fff` (هاردکد؛ کنتراست روی accent در فاز ۴ چک شود) و `--mf-warning: var(--highlight, #d98c1a)` (fallback هاردکد؛ ثبت فاز ۴).
- فونت: `inter, "YS Text", system-ui, ...` — بدون فونت فارسی و بدون تنظیم برای متن RTL؛ به فاز ۳ محول شد.

### هاردکدهای رنگ باقی‌مانده (~۴۲ مورد؛ مهم‌ترین‌ها)

| فایل | مورد | توضیح | فاز/الویت |
|---|---|---|---|
| app/topic-list.scss:537–576 | `--row-cat` با ۱۰ رنگ هاردکد (`#bf1e2e`, `#08c`, `#f7941d`, ...) | رنگ‌های badge طبقه‌بندی؛ قصد تطابق با scheme هسته | ۴/۵ – متوسط |
| app/buttons.scss:21–36 | `--d-button-*-text-color: #fff` | متن روی دکمه‌های danger/success | ۴ – کم |
| app/misc.scss:290–303 | `#c8901a`, `#b06f3c` و یک `dark-light-choose(...)` | رنگ‌های هشدار/متغیر | ۴ – کم |
| app/directory.scss و app/leaderboard.scss | `#d6a020`, `#9aa6b2`, `#c0824a` (طلایی/نقره‌ای/برنزی) | طرح جوایز؛ منطقی | بدون اقدام یا ۴ |
| app/ratings.scss:23 | `#eab308` | رنگ ستاره/امتیاز | ۴ – کم |
| app/navigation.scss:247,261 | `color-mix(#000/#fff ...)` | شفاف‌سازی سیاه/سفید | قابل قبول |
| سایه‌ها در post-voting، reactions، surfaces | `color-mix(in srgb, #000 32%..)` | سایه‌های عمومی | قابل قبول |

جمع‌بندی: معماری رنگ به‌طرزی واضح تمیزتر از میانگین تم‌هاست؛ هاردکدهای واقعی فهرست محدود و مشخصی برای فاز ۴/۵ دارند.

---

## ۵) JS و سازگاری با deprecations (۲۰۲۴–۲۰۲۶)

| فایل | الگوی استفاده | ارزیابی |
|---|---|---|
| api-initializers/main-outlet-blocks.gjs | `api.renderBlocks("main-outlet-blocks", ...)` با conditions (route/setting/viewport) | API جدید؛ نیاز به تأیید گذاشتن در نسخهٔ واقعی هستهٔ ≥ 2026.6 در فاز ۶ |
| api-initializers/sidebar-discovery-blocks.gjs | `api.renderBlocks("sidebar-discovery", ...)` برای ستون rail؛ خواندن `rail_leaderboard_id` از settings | پیوند تمیز؛ ریسک کم |
| api-initializers/topic-list-customizations.gjs | `registerValueTransformer` روی `topic-list-item-expand-pinned` و `topic-list-columns` (افزودن ستون posters در suggested) | پیوند با سیستم topic-list جدید ۲۰۲۴-۱۲؛ API عمومی. **یافتهٔ کد:** transformer `create-topic-label` (حدود خط ۹–۱۳) منطق فعلی بی‌اثر است (`value || (context.site.desktopView ? value : context.defaultKey)` خروجی همسون)؛ در فاز ۳/۵ اصلاح یا حذف شود. |
| api-initializers/docked-header-logo.js | `registerValueTransformer("home-logo-minimized", ...)` با گارد optional-call | مرتبط با هدر Glimmer جدید؛ سالم |
| api-initializers/sidebar-section-header.js | `api.modifyClass` روی `component:sidebar/user/categories-section` | تنها `modifyClass` ریپو؛ ریسک نگهداری متوسط (بازنویسی getter `headerActionsIcon`)؛ بازبینی سالانه |
| initializers/default-homepage.js | initializer کلاسیک؛ `setDefaultHomepage("latest")` فقط وقتی کاربر homepage_id نداشته باشد (null یا `-1`) | درست؛ وابسته به `after: "url-redirects"`. چک فاز ۶: تست رفتار بعد از تغییر `--default-interface` |

جمع‌بندی JS: هیچ استفاده از widgetهای منسوخ (`createWidget`، `decorateWidget`، `MountWidget`، inline scripts) در ریپو نیست؛ سازگار با سیاست‌های ۲۰۲۴–۲۰۲۶، مشروط به تأیید `renderBlocks`/transformerها روی نسخهٔ واقعی در فاز ۶.

---

## ۶) بلوک‌ها (`javascripts/discourse/blocks/*.gjs`)

هر ۱۳ بلوک از APIهای فضای تم جدید استفاده می‌کنند: `block` از `discourse/blocks` (دکوراتور `@block("theme:flat-theme:*")`)، helperهای `ui-kit` (`d-icon`، `d-number`، `d-async-content`، `d-bound-avatar-template`) و `themePrefix` از `virtual:theme`. الگو کاملاً با راهنمای ۲۰۲۶ (`.gjs`-محور) هم‌سوست.

- **i18n:** همهٔ رشته‌های UI از `themePrefix("hero.*"|"rail.*")` می‌گیرند؛ هیچ رشتهٔ هاردکد انگلیسی در gjs پیدا نشد. متغیرهای جایگذاری (`%{name}`، `%{position}`) صحیح‌اند. نکتهٔ مهم فارسی: `block-rail-events.gjs:35` از `rail.month_suffix` برای اتصال پسوند به شماره ماه استفاده می‌کند — یکی از سرنخ‌های ضروری برای فارسی‌سازی تاریخ در فاز ۳.
- **icons:** بلوک‌ها فقط از `magnifying-glass`, `award`, `arrow-right`, `calendar`, `fire`, `tag`, `plus` (و `users` در `block-rail-stats.gjs:40`) استفاده می‌کنند؛ همه در `svg_icons` موجودند. فقط `sliders` در لیست هست اما usage پیدا نشد → فاز ۵: حذف یا توجیه.
- **`block-rail-online.gjs`:** وابستگی نرم به افزونهٔ `whos-online` (`getOwner(this).lookup("service:whos-online")`) — با گارد `?.` و حالت خالی هندل شده؛ بدون استثنا. محاسبهٔ count و slice(14) در فاز ۵ برای کارایی بررسی شود.
- **`block-rail-contributors` / `block-rail-events` / `block-rail-hot-topics`:** از `ajax`، `DAsyncContent`، `relativeAge`, `getURL` استفاده می‌کنند — APIهای استاندارد هسته. قالب تاریخ/عمر نسبی بدون هندل فارسی است → فاز ۳.
- **`block-rail-profile.gjs` (۲۷۳ خط):** بزرگ‌ترین بلوک؛ در فاز ۵ برای تقسیم/کوتاه‌سازی بررسی شود.
- **settings در بلوک‌ها:** پیدا نشد (`settings.` فقط در api-initializers خوانده می‌شود و به‌صورت `args` به بلوک‌ها پاس داده می‌شود) — الگوی تمیز و مطابق مستندات.

---

## ۷) localeها، ساختار فایل‌ها و نکته‌های ریپو

- **localeها:** `en.yml`, `ru.yml`, `zh_CN.yml` (هر یک ۴۳ خط) و کلیدها با en هم‌راستا؛ **`fa.yml` وجود ندارد**. فاز ۳ از ساختار en.yml به‌عنوان مرجع کلید شروع می‌شود.
- **`common/common.scss`:** نقطهٔ تجمیع: `brand`، `app`، `blocks`، `layouts` (به‌همراه `@use "lib/viewport"`). **`mobile/mobile.scss` فقط `@import "mobile-platform"` است**، پس `mobile-platform.scss` تنها یک بار و فقط در بستهٔ موبایل بارگذاری می‌شود. (این بند در نسخهٔ اول این گزارش نادرست نوشته شده بود؛ تصحیح در بند ۱۲.) این تصمیم باید در فاز ۶ روی موبایل واقعی آزمون شود.
- **فایل بی‌کاربرد احتمالی:** `stylesheets/lib/containers.scss` — ورودی ندارد در @importها (فاز ۵ با ابزار بررسی شود).
- **asset بی‌کاربرد:** `assets/hero-background.png` در about.json ثبت شده اما در هیچ scss/gjs استفاده نمی‌شود → حذف در فاز ۵ (هم asset هم مدخل about.json).
- **`discourse-flat-theme.zip` (~۹۶KB) در ریشه:** نسخهٔ آرشیوی از خود تم؛ حذف از گیت در فاز ۵.
- **about.json:** `minimum_discourse_version: 2026.6.0` — به‌خاطر `renderBlocks`/APIهای جدید منطقی است؛ و `screenshots` ندارد (فاز ۶).

---

## ۸) جدول اجرایی (تخصیص یافته‌ها به فازها)

| # | یافته | فاز | الویت |
|---|---|---|---|
| A1 | ساخت کامل `locales/fa.yml` (۴۳ کلید با ترجمهٔ روان) | ۳ | بالا |
| A2 | فونت فارسی + fallback و `font-display` (در صورت بارگیری فونت) | ۳ | بالا |
| A3 | مهاجرت ویژگی‌های فیزیکی (`left/right`) تم به فرم منطقی + افزودن `rtl.scss` در صورت نیاز | ۳ | بالا |
| A4 | ماتریس آزمون RTL `fa_IR` (صفحات اصلی × روشن/تاریک) | ۳ | متوسط |
| B1 | سبزسازی lint ها (`selector-not-notation`، کامنت‌ها، prettier با `lint:fix`) | ۳/۵ | بالا (اول فاز ۳) |
| B2 | اصلاح یا حذف transformer بی‌اثر `create-topic-label` | ۳/۵ | متوسط |
| B3 | کنتراست `--mf-accent-fg` و دکمه‌ها در حالت تاریک | ۴ | متوسط |
| B4 | اصلاح تدریجی هاردکدهای رنگی جدول ۴ | ۴/۵ | متوسط |
| B5 | polish بلوک‌های rail و hero برای فارسی (چینش، اعداد، تاریخ) | ۴/۳ | بالا |
| B6 | آزمون رفتار واقعی `accent_color`، `ui_radius` و `content_max_width` در UI زنده | ۴/۶ | متوسط |
| C1 | کاهش `!important` (۱۷۹۵ مورد در نقطهٔ شروع) | ۵ | متوسط |
| C2 | حذف zip، asset استفاده‌نشده، icon ثبت‌شده بدون استفاده (`sliders`) و مدخل‌های منعکس | ۵ | متوسط |
| C3 | بازبینی `block-rail-profile` (۲۷۳ خط) و بارگذاری‌های async | ۵ | کم |
| D1 | ماتریس ۸ حالته فاز ۶ + افزودن `screenshots` + بازبینی `minimum_discourse_version` | ۶ | متوسط |

---

## ۹) پیوست فاز ۳ — پیشرفت واقعی (به‌روزرسانی ۲۰۲۶-۱۰-۲۱)

### انجام‌شده

| # | کار | خروجی |
|---|---|---|
| ۳-۰ | سبزسازی lint و format (B1) | `pnpm lint` کامل سبز (stylelint + eslint + ember-template-lint + prettier + ember-tsc) |
| ۳-۱ | locale فارسی (A1) | `locales/fa.yml`؛ ۳۸ کلید برگ، هم‌راستا با `en`/`ru`/`zh_CN` (تست خودکار تطابق مسیر کلیدها) |
| ۳-۲ | توکن فونت فارسی (A2) | `--mf-font-fa` در `tokens.scss` + قواعد `:lang(fa)` در `base.scss` (استک سیستمی، بدون فونت خارجی) |
| ۳-۳ | تایپوگرافی فارسی | حذف `letter-spacing` منفی برای خط پیوسته و `line-height` بازتر (`--mf-leading-relaxed`) در `:lang(fa)` |
| ۳-۴ | مهاجرت ویژگی‌های فیزیکی (A3) | `margin/padding/border/inset` چپ-راست → `inline-start/end`؛ `text-align: left/right` → `start/end`؛ گوشه‌های افقی `border-radius` → `border-start/end-*-radius` |
| ۳-۵ | `stylesheets/app/rtl.scss` | لایهٔ RTL برای `float`، آیکن‌های جهت‌دار (`scaleX(-1)`)، ناج‌های hover و آفست صفحهٔ ورود |
| ۳-۶ | اتصال | `@import "rtl";` در `stylesheets/app/_index.scss` (بدون دست‌کاری سراسری `direction`) |

### سنجش قابل‌تکرار

| سنجه | نتیجه |
|---|---|
| اعلان‌های `inline-start/end` در CSS خروجی تم | ۷۱ |
| ویژگی‌های فیزیکی باقی‌مانده (`margin/padding/border-left|right`، `text-align: left|right`) | ۰ |
| `float: inline-start` | ۵ |
| کامپایل SCSS کل تم (`brand`+`app`+`blocks`+`layouts`+`rtl`) | موفق، ۱۹٬۷۰۷ خط CSS، بدون خطا (ماژول `lib/viewport` هسته شبیه‌سازی شد) |
| تطابق کلیدهای locale | `fa` = `en` = `ru` = `zh_CN` = ۳۸ کلید برگ |
| `pnpm lint` | کد ۰ |

### ماتریس آزمون RTL (نیازمند محیط زنده)

| صفحه | روشن | تاریک | وضعیت |
|---|---|---|---|
| Discovery (hero + rail + topic list) | ⬜ | ⬜ | در انتظار آزمون زنده |
| موضوع (post stream، timeline، TOC) | ⬜ | ⬜ | در انتظار آزمون زنده |
| Composer | ⬜ | ⬜ | در انتظار آزمون زنده |
| پروفایل کاربر | ⬜ | ⬜ | در انتظار آزمون زنده |
| گروه‌ها | ⬜ | ⬜ | در انتظار آزمون زنده |
| جستجو | ⬜ | ⬜ | در انتظار آزمون زنده |
| ورود/ثبت‌نام | ⬜ | ⬜ | در انتظار آزمون زنده |

### باقی‌ماندهٔ فاز ۳

- [ ] اجرای ماتریس بالا روی نمونهٔ واقعی Discourse با `fa_IR` (نیازمند `discourse_theme watch` یا سرور آزمایشی)
- [ ] بازبینی چشمی بلوک‌های hero/rail در RTL روی همان محیط
- [ ] (تصمیم مستند) قالب اعداد/تاریخ فارسی با i18n هستهٔ Discourse می‌ماند، نه هاردکد

---

## ۱۰) پیوست فاز ۴ — ارجاع (به‌روزرسانی ۲۰۲۶-۱۰-۲۱)

بندهای بصری همین گزارش در فاز ۴ اجرا و با عدد اندازه‌گیری شد؛ گزارش کامل در `docs/04-design-log.fa.md`:

- **B3 (کنتراست accent-fg و دکمه‌ها در تاریک):** انجام شد — متن روی accent از ۳٫۱۶ به ۶٫۲۳، danger از ۲٫۹۴ به ۶٫۷۱، success از ۳٫۳۷ به ۵٫۸۴.
- **B4 (هاردکدهای رنگی):** متن/فوکوس‌ها اصلاح شدند؛ رنگ‌های badge/جایزه/ستاره به‌عنوان رنگ معنایی نگه داشته شدند و `--mf-warning` بدون تغییر ماند (دلیل در سند ۰۴).
- **B5 (polish rail/hero برای فارسی):** انجام شد — ریست tracking فارسی، ارتفاع خط بدنهٔ پست، ارقام فارسی در بلوک‌های events/online، هم‌ارزی hover/focus.
- **B6 (اثربخشی سه تنظیم):** در سطح کامپایل اثبات شد؛ ۴ شعاع هاردکد حذف شد تا `ui_radius` همهٔ گوشه‌ها را بگیرد.
- **یافته‌های تازه:** بلوک‌های `rail-links`/`rail-stats` و تنظیم `rail_links` بدون اتصال‌اند، `block-hero__chip` بدون قالب است، و دو breakpoint هاردکد وجود دارد — همه برای فاز ۵ ثبت شدند.

---

## وضعیت فاز ۲: تکمیل شد

- تمام آیتم‌های چک‌لیست فاز ۲ نقشه راه اجرا و ثبت شدند: نصب، lint/types، شمارش `!important`، انتخابگرهای سطح بالا، رنگ‌ها/فونت/تاریک، JS و deprecations، بلوک‌ها، localeها و فایل‌های بی‌کاربرد.
- خروجی نهایی: همین سند (`03-repo-audit.fa.md`) + به‌روزرسانی نقشه راه.

---

## ۱۱) پیوست فاز ۵ — تصحیح دو یافتهٔ این گزارش (۲۰۲۶-۱۰-۲۲)

- **`stylesheets/lib/containers.scss` مرده نیست:** این فایل با `@use "lib/containers" as container` در `blocks/block-hero.scss` مصرف می‌شود و باید بماند. (بند ۷ همین سند خلاف این را گفته بود.)
- **`assets/hero-background.png` و `discourse-flat-theme.zip` حذف شدند** (جمعاً ۱٬۹۰۰٬۷۱۷ بایت) و کلید `assets` و آیکن `sliders` هم از `about.json` برداشته شد.
- **`sliders`** هیچ مصرف‌کننده‌ای نداشت و حذف شد.
- وضعیت جدید `!important` و سنجه‌های سبک‌سازی در `docs/05-optimization-log.fa.md` ثبت شده است.

---

## ۱۲) پیوست ۳٫۱٫۵ — تصحیح ادعاهای بارگذاری استایل (۲۰۲۶-۱۰-۲۴)

هنگام بازبینی مستندات در نسخهٔ ۳٫۱٫۵، سه ادعای این سند با کد فعلی تطابق نداشت و اصلاح شد:

| ادعای قبلی | واقعیت کد | شاهد |
|---|---|---|
| `common/common.scss` شامل `mobile-platform` است (بند ۷) | `common/common.scss` فقط `brand`، `app`، `blocks`، `layouts` را import می‌کند | `cat common/common.scss` |
| `mobile/mobile.scss` فقط `@use "lib/viewport"` دارد (بند ۷) | محتوای آن `@import "mobile-platform";` است | `cat mobile/mobile.scss` |
| `mobile-platform.scss` روی موبایل دو بار دانلود می‌شود (بند ۹-۲ سند ۰۵ و سند ۰۶) | تنها یک import در کل ریپو دارد (`mobile/mobile.scss`) ⇒ یک بار | `grep -rn "mobile-platform" --include=*.scss .` |

اثر این تصحیح: «ادغام `mobile-platform.scss`» دیگر با انگیزهٔ حذف بارگذاری دوباره مطرح نمی‌شود؛ آن کار فقط اگر تکرار *قاعده‌ها* با `profile.scss`/`overrides.scss` آزاردهنده شد، و همچنان با آزمون زندهٔ موبایل، موضوعیت دارد.
