# بازیابی افکت بازگشت و رفتار Focus فهرست موضوعات

تاریخ: ۲۰۲۶-۱۱-۰۱  
نسخه: ۳٫۲٫۳۹  
شاخه: `freebuff-3.1.0`

## شواهد و علت

پس از Back از صفحهٔ موضوع، Discourse core ردیف را با کلاس `.highlighted` علامت‌گذاری و انیمیشن `background-fade-highlight` را برای ۲٫۵ ثانیه اجرا می‌کند. در تم رسمی، background از `rgba(16, 18, 100, 0.844)` به‌تدریج تا آلفای صفر محو شد. در تم سفارشی همان کلاس و انیمیشن وجود داشت، اما background در تمام مدت `rgba(0, 0, 0, 0)` بود. منطق ناوبری سالم بود و cascade پس‌زمینهٔ تم انیمیشن را می‌پوشاند.

قواعد مؤثر در `topic-list.scss`، `overrides.scss` و `states.scss` شامل پس‌زمینه‌های مهم برای ردیف شفاف، hover، unread/new، pinned، suggested/more-topics و selected/bulk-selected بودند. صرفاً تغییر یک selector کافی نبود؛ وضعیت‌های مهم روی خود ردیف و سلول‌های فرزند نیز باید هنگام highlight کنار می‌رفتند.

## دامنهٔ اصلاح ۳٫۲٫۳۹

- استثنای `.highlighted` برای پس‌زمینهٔ شفاف ردیف desktop/mobile.
- کناررفتن موقت پس‌زمینه‌های hover، unread/unseen/new، pinned و bulk-selected در طول highlight.
- استثنا در overrides برای unread و suggested/more-topics.
- جلوگیری از پوشاندن انیمیشن با پس‌زمینهٔ سلول‌های bulk-selected.
- حذف fill عمومی `.topic-list-item.selected > td` از states؛ fill انتخاب گروهی با `.bulk-selected` باقی است.
- بازگرداندن نشانگر Focus ردیف به `:focus-within`.
- بدون تغییر JavaScript، DOM، مسیریابی، tracking یا رنگ/مدت انیمیشن در تم.

## ماتریس آزمون پس از به‌روزرسانی

| سناریو | نتیجهٔ مورد انتظار |
|---|---|
| کلیک عنوان، ورود به موضوع و Back | افکت سرمه‌ای native حدود ۲٫۵ ثانیه دیده و سپس محو شود |
| کلیک بخش غیرعنوانی کارت و Back | افکت مشابه؛ تفاوت احتمالی Focus DOM جداگانه ثبت شود |
| ۳ ثانیه پس از Back | کلاس `.highlighted` حذف و رنگ پایه برگردد |
| Tab و Shift+Tab | Focus indicator قابل مشاهده باشد |
| unread/new | highlight موقتاً دیده شود؛ tint و badge پس از آن حفظ شوند |
| pinned | highlight موقتاً دیده شود؛ رنگ pinned بعد از آن برگردد |
| bulk selection | fill انتخاب گروهی پس از پایان highlight حفظ شود |
| suggested/more-topics | انیمیشن زیر background شفاف/hover پنهان نشود |
| thumbnail grid/masonry/minimal/blog-style | ظاهر اختصاصی کارت‌ها بدون تغییر بماند |
| روشن/تاریک، دسکتاپ/موبایل و عرض‌های مختلف | رنگ و layout بدون تغییر ناخواسته |

### بررسی Console

```js
const id = "6681";
const row = document.querySelector(`.topic-list-item[data-topic-id="${id}"]`);
const s = row && getComputedStyle(row);
console.log({
  classes: row?.className,
  backgroundColor: s?.backgroundColor,
  animationName: s?.animationName,
  animationDuration: s?.animationDuration,
  activeElement: document.activeElement?.tagName,
});
```

در مدت highlight باید کلاس `.highlighted`، انیمیشن `background-fade-highlight` و background غیرشفاف وجود داشته باشد؛ سپس کلاس حذف شود.

## وضعیت اعتبارسنجی

شواهد پیش از اصلاح از مرورگر زنده‌اند. CSS و مستندات در شاخه ثبت شده‌اند، اما lint/build محلی و ماتریس زندهٔ نسخهٔ اصلاح‌شده هنوز اجرا نشده‌اند. تا پایان آزمون بالا، اصلاح را «ثبت‌شده؛ تأیید زنده در انتظار» بدانید.

## بازگشت امن

روش پیشنهادی برای بازگرداندن کامل این مجموعه تغییرات (از نخستین commit کد تا آخرین commit مستندات):

```bash
git switch freebuff-3.1.0
git pull --ff-only origin freebuff-3.1.0
git revert --no-commit 5d6fd8c^..704ec3e
git commit -m "revert: restore topic-list highlight and focus behavior"
git push origin freebuff-3.1.0
```

این روش commit معکوس می‌سازد و تاریخچه را بازنویسی نمی‌کند؛ از `reset --hard` و force-push استفاده نکنید. برای بازگشت جزئی، فایل‌های topic-list.scss، overrides.scss و states.scss را مطابق بخش «دامنهٔ اصلاح» بررسی کنید و rollback را در commit جدید مستند کنید.

## محدودیت مهم

این CSS تضمین نمی‌کند که کلیک روی هر بخش غیرعنوانی کارت، مرورگر را وادار به Focus کردن لینک عنوان کند. آن رفتار به کامپوننت مسیریابی وابسته است و عمداً در این اصلاح تغییر نکرده؛ اگر تفاوتی با تم رسمی باقی ماند، ابتدا DOM و رویدادهای Focus در هر دو تم ثبت شود و سپس دربارهٔ تغییر JS تصمیم بگیریم.

## ۷) بررسی سورس هسته و تطبیق فراخوانی Focus — ۲۰۲۶-۱۱-۰۱

### ۷-۱) مسیر بومی در Discourse core

نسخهٔ مرجع هستهٔ انجمن: `568a006ad8f5d8ae59af64edbd33a151d36fdbde`.

در `frontend/discourse/app/components/topic-list/item.gjs`:

- خطوط ۴۳–۵۳: modifierِ `highlightIfNeeded` شناسهٔ موضوع ردیف را با `historyStore.lastTopicIdViewed` مقایسه می‌کند؛ در صورت تطبیق، `data-is-last-viewed-topic` را تنظیم و `highlightRow(element)` را اجرا می‌کند.
- خطوط ۵۰–۵۳: اگر `shouldFocusLastVisited` درست باشد، با `next()` عنوان `.main-link .title` را Focus می‌کند.
- خطوط ۱۰۲–۱۰۴: شرط آن فقط `site.desktopView && args.focusLastVisitedTopic` است.
- خطوط ۱۴۶–۱۴۸: `navigateToTopic` پیش از مسیریابی شناسهٔ موضوع را در `historyStore.lastTopicIdViewed` ذخیره می‌کند.
- در `frontend/discourse/app/components/discovery/topics.gjs` خطوط ۲۷۱–۲۷۳، هر دو گزینهٔ `focusLastVisitedTopic` و `highlightLastVisited` در فهرست Discovery فعال‌اند.

بنابراین وجود Focus خودکار عنوان پس از بازگشت از موضوع، رفتار صریح هسته است؛ تم برای ایجاد این رفتار به JavaScript سفارشی نیاز ندارد.

### ۷-۲) مقایسهٔ دو audit قبلی

**تم رسمی:**
- audit رویدادهای Focus، Focus عنوان موضوع ۶۶۸۱ را حدود ۱۰۶۴ میلی‌ثانیه پس از شروع ثبت نشان داد؛ Focus حدود ۳۶۵ میلی‌ثانیه باقی ماند.
- audit جداگانهٔ monkey-patch روی `HTMLElement.prototype.focus` هیچ فراخوانی مستقیمی روی عنوان موضوع هدف ثبت نکرد.
- فراخوانی‌های ثبت‌شده مربوط به دکمه‌های منو و چرخهٔ تخریب modifierها بودند.
- بنابراین Focus مشاهده‌شده در audit رویدادها لزوماً ناشی از فراخوانی مستقیم JS ثبت‌شده نیست؛ بازیابی Focus توسط مرورگر یا تفاوت زمان‌بندی/ثبت همچنان ممکن است.

**تم سفارشی:**
- چهار فراخوانی نخست روی دکمه‌های منو و با stack مربوط به lifecycle تخریب منوها بودند.
- فراخوانی پنجم مستقیماً روی `a.title.raw-link.raw-topic-link` در ردیف موضوع ۶۶۸۱ ثبت شد.
- در لحظهٔ ثبت، ردیف دارای `.visited.highlighted` بود.
- stack شامل اجرای زمان‌بندی‌شدهٔ هسته و مسیر مرتبط با `composerResized` و افزونهٔ Chat بود؛ با این حال، زمان نسبی حدود ۳۸ ثانیه پس از نصب audit بود و به‌تنهایی ثابت نمی‌کند که این فراخوانی دقیقاً در اثر Back یا تغییر تم ایجاد شده است.

### ۷-۳) نتایج تکمیلی auditهای مقایسه‌ای

**اجرای تم سفارشی با کلیک روی بخش غیرعنوانی کارت:**
- ورود به موضوع از طریق `A.topic-excerpt` با `focusin` ثبت شد؛ بنابراین کلیک غیرعنوانی واقعاً از عنوان متمایز بوده است.
- در یک اجرای جداگانه، پس از Back فراخوانی مستقیم `HTMLElement.prototype.focus()` روی عنوان موضوع ۶۶۸۱ و سپس `focusin` همان عنوان ثبت شد.
- stack این فراخوانی به callback زمان‌بندی‌شده و مسیر `debouncedRecalculateHeaderOffset` می‌رسید؛ این مسیر به‌تنهایی منشأ منطقی Focus را مشخص نمی‌کند و انتساب قطعی آن به Chat/Composer یا خود تم ممکن نیست.

**اجرای تم رسمی با کلیک روی بخش غیرعنوانی کارت:**
- ورود به موضوع از طریق `A.topic-excerpt` و خروج Focus از آن هنگام ورود به صفحهٔ موضوع ثبت شد.
- پس از `popstate` و بازگشت به `/latest`، هیچ `focusin` یا فراخوانی مستقیم `focus()` روی عنوان موضوع ۶۶۸۱ ثبت نشد.
- پنج فراخوانی مستقیم پس از بازگشت روی triggerهای منو، bookmark و notifications بودند؛ stackها آن‌ها را به `close → destroy → destroyModifier` مربوط می‌کردند، نه Focus عنوان.

### ۷-۴) جمع‌بندی نهایی و حدود نتیجه

- سورس هسته وجود مسیر Focus خودکار عنوان آخرین موضوع را اثبات می‌کند؛ Discovery این قابلیت را فعال می‌سازد.
- رفتار واقعی Focus در auditهای مرورگر یکنواخت نبود: در برخی اجراها Focus عنوان پس از بازگشت مشاهده شد و در برخی اجراها، از جمله اجرای اخیر تم رسمی با کلیک غیرعنوانی، مشاهده نشد.
- در یک اجرای تم سفارشی، فراخوانی مستقیم Focus عنوان پس از Back ثبت شد؛ در اجرای اخیر تم رسمی چنین فراخوانی‌ای ثبت نشد. این تفاوت مشاهده‌شده است، اما به‌دلیل تفاوت شرایط و نبود کنترل کامل اجراها، رابطهٔ علّی آن با تم اثبات نشده است.
- رویداد `popstate` فقط تغییر تاریخچه/مسیر را نشان می‌دهد و زمان پایان render یا اجرای modifier را تعیین نمی‌کند.
- فراخوانی‌های Focus روی triggerهای منو و lifecycle تخریب آن‌ها نباید به‌عنوان Focus عنوان تفسیر شوند.
- ارتباط stack زمان‌بندی‌شده با `debouncedRecalculateHeaderOffset`، Chat یا Composer نیز اثبات نشده است.
- خطای 404 درخواست `discourse-post-event/events` در این بررسی مشاهده شد، اما هیچ شاهدی از ارتباط آن با Focus به دست نیامد؛ خارج از دامنهٔ این نتیجه باقی می‌ماند.

**تصمیم نهایی: بررسی Focus پس از Back در این مرحله بسته شد.** علت تفاوت مشاهده‌شده با شواهد موجود قابل تعیین نیست و ادامهٔ auditهای تکراری ارزش تشخیصی کافی ندارد. هیچ تغییر JS یا CSS برای وادارکردن Focus عنوان اعمال نمی‌شود و این موضوع در وضعیت فعلی به‌عنوان رفتار حل‌نشده/بدون اقدام ثبت می‌شود. فقط در صورت ظهور شواهد یا مسئلهٔ عملی تازه، بررسی جدیدی با سؤال مشخص تعریف شود.
