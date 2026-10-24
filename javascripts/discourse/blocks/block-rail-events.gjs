import Component from "@glimmer/component";
import { themePrefix } from "virtual:theme";
import { block } from "discourse/blocks";
import { ajax } from "discourse/lib/ajax";
import { bind } from "discourse/lib/decorators";
import DAsyncContent from "discourse/ui-kit/d-async-content";
import dIcon from "discourse/ui-kit/helpers/d-icon";
import I18n, { i18n } from "discourse-i18n";

// Core formats every other date in Discourse on the Gregorian calendar, so the
// rail badge keeps that calendar and the event day never disagrees with the
// post timestamps next to it. The month name and the digits still come from the
// reader's locale: `Oct / 24`, `اکتبر / ۲۴`, `окт. / 24`, `10月 / 24`. Names are
// supplied by the platform's Intl data through the same BCP47 locale core uses,
// so no month strings are stored in the theme and any locale Discourse gains
// works without a theme change.
const formatterCache = new Map();

function formattersFor(locale) {
  let formatters = formatterCache.get(locale);

  if (!formatters) {
    formatters = {
      month: new Intl.DateTimeFormat(locale, {
        calendar: "gregory",
        month: "short",
      }),

      // The day is read from `formatToParts` instead of `format`, because a
      // whole-day format appends the locale's unit in CJK locales ("24日");
      // the badge shows the month on its own line and only needs the number.
      day: new Intl.DateTimeFormat(locale, {
        calendar: "gregory",
        day: "numeric",
      }),
    };

    formatterCache.set(locale, formatters);
  }

  return formatters;
}

function localizedDateParts(date) {
  const { day, month } = formattersFor(I18n.currentBcp47Locale || "en");
  const dayOnly = day
    .formatToParts(date)
    .find((part) => part.type === "day")?.value;

  return { day: dayOnly, month: month.format(date) };
}

@block("theme:flat-theme:rail-events", {
  description: "Upcoming events from discourse-post-event",
})
export default class BlockRailEvents extends Component {
  @bind
  async fetchEvents() {
    try {
      const after = new Date().toISOString();
      const before = new Date(
        Date.now() + 180 * 24 * 60 * 60 * 1000
      ).toISOString();
      const { events } = await ajax("/discourse-post-event/events", {
        data: {
          limit: 3,
          after,
          before,
          include_ongoing: true,
        },
      });

      return (events || [])
        .map((event) => ({ event, startsAt: new Date(event.starts_at) }))
        .filter(({ startsAt }) => !Number.isNaN(startsAt.getTime()))
        .slice(0, 3)
        .map(({ event, startsAt }) => ({
          href: event.post?.url || "/upcoming-events",
          title: event.name || event.post?.topic?.title || "",
          date: localizedDateParts(startsAt),
        }));
    } catch {
      return [];
    }
  }

  <template>
    <DAsyncContent @asyncData={{this.fetchEvents}}>
      <:content as |events|>
        {{#if events.length}}
          <section class="block-rail-panel block-rail-events">
            <h4 class="block-rail-panel__title">
              {{dIcon "calendar"}}
              <span>{{i18n (themePrefix "rail.events_title")}}</span>
            </h4>
            <ul class="block-rail-events__list">
              {{#each events as |event|}}
                <li>
                  <a class="block-rail-events__item" href={{event.href}}>
                    <span class="block-rail-events__date">
                      <span
                        class="block-rail-events__month"
                      >{{event.date.month}}</span>
                      <span
                        class="block-rail-events__day"
                      >{{event.date.day}}</span>
                    </span>
                    <span class="block-rail-events__name">{{event.title}}</span>
                  </a>
                </li>
              {{/each}}
            </ul>
            <a class="block-rail-panel__more" href="/upcoming-events">
              <span>{{i18n (themePrefix "rail.show_all")}}</span>
              {{dIcon "arrow-right"}}
            </a>
          </section>
        {{/if}}
      </:content>
    </DAsyncContent>
  </template>
}
