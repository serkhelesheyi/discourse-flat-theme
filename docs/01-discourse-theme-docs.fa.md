# ۱. جمع‌بندی مستندات تم‌های Discourse

> **کاربری این سند:** پیش‌نیاز فاز ۱ نقشه راه (`02-roadmap.fa.md`) است. هر کارشناسی که پروژه را ادامه می‌دهد باید این سند را قبل از هر تغییری بخواند. آخرین بازبینی مستندات: ۲۰۲۶-۱۰-۲۰.

منابع: مخزن رسمی `discourse/discourse` (پوشه `docs/developer-guides`)، مخزن `discourse_theme`، صفحات راهنمای Meta Discourse. لینک منابع در پایان هر بخش آمده است.

---

## الف) آناتومی و ساختار تم

یک تم Remote، پوشه‌ای نسخه‌بندی‌شده است که Discourse مستقیماً از گیت می‌خواند.

| اجباری | اختیاری |
|---|---|
| `about.json` | `common/*.scss`، `desktop/`، `mobile/` |
| | `common/head.html` / `common/body.html` (hook های آزمایشی) |
| | `settings.yml` و `locales/*.yml` |
| | `javascripts/discourse/api-initializers/*` و فایل‌های `.gjs` |
| | `stylesheets/*` و `assets/*` |

- کلید `"component": true` در about.json تم را به Theme Component تبدیل می‌کند (مکمل تم اصلی). تم ما `component: false` است؛ یعنی Full Theme مستقل.
- **هشدار مهم (۲۰۲۶):** پسوند `.hbs` در تم‌ها و افزونه‌ها منسوخ شده و پس از نسخه ESR بعدی حذف می‌شود. برای کد جدید مبنا باید `.gjs` (Glimmer components) باشد.
- اجزای قابل‌استفاده‌مجدد تم در این ریپو «block» نامیده می‌شوند: UI در `javascripts/discourse/blocks/*.gjs` و استایل در `stylesheets/blocks/*.scss`.

منابع: [معیار ساختار تم در مخزن رسمی](https://github.com/discourse/discourse/blob/main/docs/developer-guides/docs/05-themes-components/06-theme-structure.md) · [Developing Discourse Themes](https://meta.discourse.org/t/developing-discourse-themes-theme-components/93648) · [Deprecating .hbs](https://meta.discourse.org/t/deprecating-hbs-file-extension-in-themes-and-plugins/398896)

---

## ب) رنگ‌ها و طراحی

- **قانون طلایی:** رنگ‌ها از **CSS custom properties** هسته گرفته شوند (`var(--primary)`، `var(--secondary)`، `var(--tertiary)`، `var(--header_background)`، `var(--highlight)`، `var(--danger)`، `var(--success)` و ...). نه مقادیر ثابت و نه SCSS variables قدیمی مانند `$primary` که منسوخ شده‌اند.
- متغیرهای هسته به color scheme فعال وابسته‌اند؛ پس تعویض scheme به‌طور خودکار رنگ‌های تم را عوض می‌کند و پشتیبانی dark mode خودکار هم از همین مسیر می‌آید.
- برای رنگ شفاف، متغیرهای کمکی مانند `--primary-rgb` در دسترس‌اند.
- اگر تم به رنگ دلخواهی نیاز دارد که با حالت روشن/تاریک عوض شود، باید در `common/color_definitions.scss` با `dark-light-choose()` تعریف گردد؛ نه با هاردکد.
- **رویهٔ کم‌ریسک:** رنگ را تا جای ممکن از scheme بگیر؛ بازنویسی گستردهٔ استایل کامپوننت‌های هسته را نقطه‌سنگین نگه دار و در حداقل نگهش دار.

منابع: [Core Variables](https://github.com/discourse/discourse/blob/main/docs/developer-guides/docs/05-themes-components/13-core-variables.md) · [Automatic Dark Mode](https://meta.discourse.org/t/update-themes-and-plugins-to-support-automatic-dark-mode/161595)

---

## ج) تنظیمات تم (settings.yml)

- تنظیمات مدیر سایت فقط در `settings.yml` تعریف می‌شوند، نه در ویرایشگر CSS/HTML.
- نوع‌های مجاز: `integer`, `float`, `string`, `bool`, `list`, `enum`, `objects`, `upload`, `icon` (برای `enum` گزینه‌های مجاز الزامی است).
- برای تنظیمات ساختاریافتهٔ جدید از نوع `objects` استفاده کنید، نه `json_schema` (قدیمی).
- دسترسی در JS: `settings.setting_name`.
- این ریپو درست از `objects` استفاده کرده (`rail_links`) که خروجی‌اش بلوک `block-rail-links` است.

منابع: [Add Settings to Your Theme](https://meta.discourse.org/t/add-settings-to-your-discourse-theme/82557) · [objects type](https://meta.discourse.org/t/objects-type-for-theme-setting/305009)

---

## د) RTL و محتوای فارسی (بخش حیاتی برای این پروژه)

نکتهٔ محوری: **سیستم RTL، CSS تم را به‌طور خودکار mirror نمی‌کند.** فقط هستهٔ Discourse از RTLcss استفاده می‌کند. پس تمی که در حالت LTR درست است، در فارسی/عربی الزاماً درست نمایش داده نمی‌شود.

- ابزار مستند برای اصلاحات RTL در تم، استایل با انتخابگر `.rtl` است.
- در CSS جدید باید **ویژگی‌های منطقی** استفاده کرد: `margin-inline`، `padding-inline`، `margin-block`، `inset-inline`، `border-start-*`، `text-align: start/end` و ... . این ویژگی‌ها خودشان با جهت سند عوض می‌شوند و نیاز به mirror دستی را از بین می‌برد.
- مسیر آزمون: فعال کردن locale راست‌به‌چپ (به‌خصوص `fa_IR`) و بررسی صفحات اصلی تا خطای چینش شناسایی شود.

**جمع‌بندی برای ما:** ۱) در استایل‌های تم خود `direction` را دست نمی‌زنیم؛ ۲) استایل‌های موجود را به‌جای `left/right` به ویژگی‌های منطقی مهاجرت می‌دهیم (فاز RTL در نقشه راه)؛ ۳) آزمون نهایی روی `fa_IR` انجام می‌شود.

منبع: [Indicate which themes support RTL locales](https://meta.discourse.org/t/indicate-which-themes-and-components-are-safe-to-use-with-rtl-locales/284922)

---

## هـ) Deprecations و تغییرات اثرگذار (۲۰۲۴–۲۰۲۶)

هر یک از این موارد می‌تواند تم موجود را بشکند و باید در بازبینی گیت‌هاب تم بررسی شود:

| موضوع | تاریخ | اثر | راهکار |
|---|---|---|---|
| بازآرایی مسیرهای Discovery | 2023-11 | override کردن templateهای قدیمی بی‌صدا می‌افتد یا خطا می‌دهد | فقط plugin outletها و route nameها؛ بازنویسی templateهای ClientRoute نکنید |
| تغییر Header (Glimmer) | 2024 | APIهای `decorateWidget`، `addToHeaderIcons`، `addHeaderPanel` منسوخ | APIهای جدید هدر/Glimmer |
| پایان عمر سامانهٔ Widget | 2025 | `createWidget`، `reopenWidget`، `MountWidget` از کار افتاده | Glimmer components + plugin outlet |
| اسکریپت‌های inline | 2025 | `<script type="text/discourse-plugin">` و `text/x-handlebars` منسوخ | کد به `api-initializers` منتقل شود |
| فایل‌های `.hbs` | 2026 | پس از ESR بعدی حذف | مهاجرت به `.gjs` |
| topic-list | 2024-12 | پیاده‌سازی فهرست موضوع‌ها تغییر ساختار داد | راهنمای مهاجرت مخصوص همان تغییر |

**جمع‌بندی برای ما:** این تم از `.gjs` و `api-initializers` استفاده می‌کند و فایل `.hbs` ندارد. نقاط حساس بازبینی: `main-outlet-blocks`، `topic-list-customizations`، `dock-header-logo` و سازگاری با تغییرات Discovery/topic-list/header.


منابع: [Discovery refactor](https://meta.discourse.org/t/november-2023-refactoring-discovery-routes-how-will-it-affect-my-theme-plugin/282816) · [topic-list changes](https://meta.discourse.org/t/upcoming-topic-list-changes-how-to-prepare-themes-and-plugins/343404) · [Header changes](https://meta.discourse.org/t/upcoming-header-changes-preparing-themes-and-plugins/296544) · [Widget EOL](https://meta.discourse.org/t/upcoming-eol-for-the-widget-rendering-system/375332) · [Inline scripts](https://meta.discourse.org/t/modernizing-inline-script-tags-for-templates-js-api/366482)

---

## و) تست و ابزارها

- ابزار رسمی `discourse_theme` (gem) با دستورات `new`، `download`، `watch`، `upload`، `rspec`. با `watch` تغییرات به‌صورت زنده روی پیش‌نمایش اعمال می‌شود و هیچ ابزار توسعه‌ای بهتر از آن نیست. پیش‌نیاز: دسترسی به یک نمونهٔ Discourse (محلی یا سرور اصلی) و API key.
- `about.json` کلید `screenshots` را می‌پذیرد (پوشه `screenshots/` با حداکثر ۲ تصویر روشن/تاریک). توصیهٔ ۲۰۲۵: نسبت ۱۶:۹، 2560×1440 یا بزرگ‌تر، حداکثر ۱ مگابایت.
- **الگوریتم آزمون هر فاز:** حالت روشن / حالت تاریک / دسکتاپ / موبایل / و برای پشتیبانی فارسی: locale `fa_IR` با بررسی صفحات اصلی، کامپوننت‌ها و بی‌خطا بودن شناختی.

منابع: [discourse_theme CLI](https://github.com/discourse/discourse_theme) · [about.json screenshots](https://meta.discourse.org/t/adding-metadata-and-screenshots-to-a-theme/119205) · [Minimizing maintenance](https://meta.discourse.org/t/minimizing-maintenance-on-theme-customizations/261388)

---

## خ) جمع‌بندی یک خطی

> توسعه با CSS افزوده، متغیرهای CSS هسته، تنظیمات YAML و APIهای عمومی/outletها؛ پرهیز از بازنویسی گستردهٔ هسته؛ و آزمون هر release در حالت‌های روشن/تاریک، دسکتاپ/موبایل و RTL فارسی.
