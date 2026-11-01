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

روش پیشنهادی پس از دریافت commit نهایی این اصلاح:

```bash
git switch freebuff-3.1.0
git pull --ff-only origin freebuff-3.1.0
git revert <FIX_COMMIT_SHA>
git push origin freebuff-3.1.0
```

این روش commit معکوس می‌سازد و تاریخچه را بازنویسی نمی‌کند؛ از `reset --hard` و force-push استفاده نکنید. برای بازگشت جزئی، فایل‌های topic-list.scss، overrides.scss و states.scss را مطابق بخش «دامنهٔ اصلاح» بررسی کنید و rollback را در commit جدید مستند کنید.

## محدودیت مهم

این CSS تضمین نمی‌کند که کلیک روی هر بخش غیرعنوانی کارت، مرورگر را وادار به Focus کردن لینک عنوان کند. آن رفتار به کامپوننت مسیریابی وابسته است و عمداً در این اصلاح تغییر نکرده؛ اگر تفاوتی با تم رسمی باقی ماند، ابتدا DOM و رویدادهای Focus در هر دو تم ثبت شود و سپس دربارهٔ تغییر JS تصمیم بگیریم.
