import Component from "@glimmer/component";
import { themePrefix } from "virtual:theme";
import { block } from "discourse/blocks";
import dIcon from "discourse/ui-kit/helpers/d-icon";
import { i18n } from "discourse-i18n";

// 3.2.0 and 3.2.1 shipped this sentence as the setting's default, and a theme
// setting that was saved once keeps its stored value. Reading it as "unset"
// means the hero follows the reader's language instead of staying English on a
// Persian or Russian site. On an English site the localized default is the same
// sentence, so the fallback changes nothing there.
const LEGACY_DEFAULT_SUBTITLE =
  "Hooray! Enjoy your stay! Feel free to ask questions or search existing posts.";

@block("theme:flat-theme:hero", {
  description: "Centered discovery hero with branding image and search",
  args: {
    subtitle: { type: "string" },
  },
})
export default class BlockHero extends Component {
  get subtitle() {
    const configured = this.args.subtitle?.trim();

    if (!configured || configured === LEGACY_DEFAULT_SUBTITLE) {
      return i18n(themePrefix("hero.default_subtitle"));
    }

    return configured;
  }

  <template>
    <section class="block-hero">
      <div class="block-hero__inner">
        <div class="block-hero__copy">
          <h1 class="block-hero__title">{{i18n (themePrefix "hero.title")}}</h1>
          <p class="block-hero__subtitle">{{this.subtitle}}</p>
        </div>

        <form
          class="block-hero__search"
          action="/search"
          method="get"
          role="search"
        >
          <span class="block-hero__search-icon" aria-hidden="true">
            {{dIcon "magnifying-glass"}}
          </span>
          <input
            type="search"
            name="q"
            placeholder={{i18n (themePrefix "hero.search_placeholder")}}
            aria-label={{i18n (themePrefix "hero.search_label")}}
            autocomplete="off"
          />
        </form>
      </div>
    </section>
  </template>
}
