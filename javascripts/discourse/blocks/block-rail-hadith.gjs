import Component from "@glimmer/component";
import { action } from "@ember/object";
import { tracked } from "@glimmer/tracking";
import { themePrefix } from "virtual:theme";
import { block } from "discourse/blocks";
import dIcon from "discourse/ui-kit/helpers/d-icon";
import { i18n } from "discourse-i18n";

const HADITHS = [
  {
    arabic: "إِنَّمَا الْأَعْمَالُ بِالنِّيَّاتِ",
    source: "صحيح البخاري، حديث ١",
    translation: "ارزش اعمال به نیت‌هاست.",
  },
  {
    arabic: "الدِّينُ النَّصِيحَةُ",
    source: "صحيح مسلم، حديث ٥٥",
    translation: "دین، خیرخواهی است.",
  },
  {
    arabic: "مَنْ كَانَ يُؤْمِنُ بِاللَّهِ وَالْيَوْمِ الْآخِرِ فَلْيَقُلْ خَيْرًا أَوْ لِيَصْمُتْ",
    source: "صحيح البخاري، حديث ٦٠١٨؛ صحيح مسلم، حديث ٤٧",
    translation: "هر کس به خدا و روز واپسین ایمان دارد، باید سخن نیک بگوید یا سکوت کند.",
  },
];

@block("theme:flat-theme:rail-hadith", {
  description: "Random short hadith from a local list; no network request",
})
export default class BlockRailHadith extends Component {
  @tracked isExpanded = false;
  hadith = HADITHS[Math.floor(Math.random() * HADITHS.length)];

  @action
  toggleExpanded() {
    this.isExpanded = !this.isExpanded;
  }

  <template>
    {{#if this.hadith}}
      <section class="block-rail-panel block-rail-hadith">
        <h4 class="block-rail-panel__title">
          {{dIcon "book-open"}}
          <span>{{i18n (themePrefix "rail.hadith_title")}}</span>
        </h4>
        <div class="block-rail-hadith__body {{if this.isExpanded 'is-expanded' 'is-collapsed'}}">
          <p class="block-rail-hadith__arabic" lang="ar" dir="rtl">{{this.hadith.arabic}}</p>
          {{#if this.hadith.translation}}
            <p class="block-rail-hadith__translation" lang="fa" dir="rtl">{{this.hadith.translation}}</p>
          {{/if}}
        </div>
        <p class="block-rail-hadith__source" dir="rtl">{{this.hadith.source}}</p>
        <button
          type="button"
          class="block-rail-hadith__toggle"
          aria-expanded={{this.isExpanded}}
          {{on "click" this.toggleExpanded}}
        >
          {{#if this.isExpanded}}
            <span>{{i18n (themePrefix "rail.hadith_less")}}</span>
            {{dIcon "chevron-up"}}
          {{else}}
            <span>{{i18n (themePrefix "rail.hadith_more")}}</span>
            {{dIcon "chevron-down"}}
          {{/if}}
        </button>
      </section>
    {{/if}}
  </template>
}
