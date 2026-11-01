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

### ۷-۳) نتیجهٔ معتبر و محدودیت

- منطق بومی فوکوس در سورس هسته اثبات شد.
- مشاهدهٔ فراخوانی مستقیم روی عنوان در audit تم سفارشی با مسیر بومی هسته سازگار است.
- تفاوت دو audit هنوز علت‌یابی نشده است؛ به‌ویژه، عدم ثبت فراخوانی مستقیم در تم رسمی را نباید معادل عدم وقوع Focus دانست.
- ارتباط افزونهٔ Chat/رویداد `composerResized` با زمان‌بندی فراخوانی هنوز اثبات نشده است.
- این بررسی هیچ تغییر JavaScript یا CSS را توجیه نمی‌کند و در این مرحله هیچ تغییری در کد اعمال نشده است.

### ۷-۴) آزمون بعدی؛ فقط برای پاسخ به سؤال باقیمانده

یک A/B کنترل‌شده در تم رسمی و سفارشی لازم است. در هر دو اجرا باید مرورگر، پروفایل، اندازهٔ viewport، zoom، وضعیت Chat و Composer، موضوع هدف، نوع کلیک و فاصلهٔ زمانی Back یکسان باشد. برای هر تم دو مسیر جدا ثبت شود: (۱) کلیک روی عنوان موضوع و Back؛ (۲) کلیک روی بخش غیرعنوانی کارت و Back.

برای هر اجرا باید زمان و stack فراخوانی‌های `HTMLElement.prototype.focus`، رویدادهای `focusin/focusout`، `document.activeElement`، کلاس‌های `selected/highlighted/visited` و زمان ظاهر/حذف `.highlighted` ثبت شود. audit باید پیش از کلیک آغاز شود و ثبت تا دست‌کم ۴ ثانیه پس از Back ادامه یابد؛ زمان نصب audit به‌تنهایی معیار زمان‌بندی رویداد نیست.

**تا دریافت این چهار trace، تفاوت Focus حل‌نشده باقی می‌ماند.** اجرای مجدد auditهای قبلی بدون یکسان‌سازی شرایط، ارزش تشخیصی تازه‌ای ندارد.
