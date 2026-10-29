import Component from "@glimmer/component";
import { concat } from "@ember/helper";
import { service } from "@ember/service";
import { themePrefix } from "virtual:theme";
import { block } from "discourse/blocks";
import UserBadge from "discourse/components/user-badge";
import { ajax } from "discourse/lib/ajax";
import { bind } from "discourse/lib/decorators";
import { prioritizeNameInUx } from "discourse/lib/settings";
import User from "discourse/models/user";
import { userPath } from "discourse/lib/url";
import { or } from "discourse/truth-helpers";
import DAsyncContent from "discourse/ui-kit/d-async-content";
import dBoundAvatarTemplate from "discourse/ui-kit/helpers/d-bound-avatar-template";
import dIcon from "discourse/ui-kit/helpers/d-icon";
import { i18n } from "discourse-i18n";

@block("theme:flat-theme:rail-profile", {
  description: "Current user summary styled after the core user card",
  args: {
    maxBadges: { type: "number", integer: true, default: 4 },
  },
})
export default class BlockRailProfile extends Component {
  @service currentUser;

  get maxBadges() {
    const max = Number(this.args.maxBadges);
    return Number.isFinite(max) && max > 0 ? max : 4;
  }

  // `card.json` carries trust level, badge count and featured badges in a
  // single request, unlike the current user payload which has none of them.
  @bind
  async fetchProfile() {
    const username = this.currentUser?.username;

    if (!username) {
      return null;
    }

    let user;

    try {
      user = await User.findByUsername(username, { forCard: true });
    } catch {
      return null;
    }

    // The card serializer intentionally omits topic_count/post_count. The
    // summary endpoint exposes them only when the viewer may see summary stats.
    // Keep the profile card usable if that optional request fails.
    let summary = {};
    try {
      summary = await ajax(userPath(`${username}/summary.json`));
    } catch {
      // Counts are optional; identity, dates and badges should still render.
    }

    const nameFirst = prioritizeNameInUx(user.name);
    const badges = (user.featured_user_badges || [])
      .filter(Boolean)
      .slice(0, this.maxBadges);

    const trustLevelName = this.#trustLevelName(user.trust_level);

    return {
      user,
      primaryName: nameFirst ? user.name : user.username,
      secondaryName: this.#secondaryName(user, nameFirst),
      title: this.#displayTitle(user.title, trustLevelName),
      trustLevelName,
      lastPostedAt: this.#formatDate(user.last_posted_at),
      createdAt: this.#formatDate(user.created_at),
      topics: this.#formatCount(summary.topic_count),
      posts: this.#formatCount(summary.post_count),
      badges,
      moreBadgesCount: Math.max((user.badge_count ?? 0) - badges.length, 0),
    };
  }

  #secondaryName(user, nameFirst) {
    const secondary = nameFirst ? user.username : user.name;

    if (!secondary) {
      return null;
    }

    const primary = nameFirst ? user.name : user.username;

    if (secondary.toLowerCase() === primary?.toLowerCase()) {
      return null;
    }

    return secondary;
  }

  #trustLevelName(level) {
    const keys = ["newuser", "basic", "member", "regular", "leader"];
    const key = keys[Number(level)];

    if (!key) {
      return null;
    }

    // Core Discourse keys follow the site interface language.
    return i18n(`trust_levels.names.${key}`);
  }

  // Skip titles that just repeat the trust level (often "Leader" while the
  // locale already shows "领导者").
  #displayTitle(title, trustLevelName) {
    if (!title) {
      return null;
    }

    const normalized = title.trim().toLowerCase();
    const trustNames = [
      trustLevelName,
      "new user",
      "basic user",
      "member",
      "regular",
      "leader",
      "新用户",
      "基本用户",
      "成员",
      "活跃用户",
      "常规用户",
      "领导者",
    ]
      .filter(Boolean)
      .map((name) => name.trim().toLowerCase());

    if (trustNames.includes(normalized)) {
      return null;
    }

    return title;
  }

  #formatCount(value) {
    const count = Number(value);

    if (!Number.isFinite(count)) {
      return null;
    }

    return count.toLocaleString();
  }

  // Locale-independent year-month-day, so the rail never falls back to the
  // month-first ordering the core date helpers use for English.
  #formatDate(value) {
    if (!value) {
      return null;
    }

    const date = new Date(value);

    if (isNaN(date.getTime())) {
      return null;
    }

    const month = String(date.getMonth() + 1).padStart(2, "0");
    const day = String(date.getDate()).padStart(2, "0");

    return `${date.getFullYear()}-${month}-${day}`;
  }

  <template>
    {{#if this.currentUser}}
      <DAsyncContent @asyncData={{this.fetchProfile}}>
        <:content as |model|>
          {{#if model}}
            <section class="block-rail-panel block-rail-profile">
              <div class="block-rail-profile__identity">
                <a
                  class="block-rail-profile__avatar"
                  href={{model.user.path}}
                  aria-label={{model.user.username}}
                >
                  {{dBoundAvatarTemplate model.user.avatar_template "huge"}}
                </a>
                <div class="block-rail-profile__names">
                  <div class="block-rail-profile__name-row">
                    <a
                      class="block-rail-profile__name"
                      href={{model.user.path}}
                    >{{model.primaryName}}</a>
                    {{#if model.trustLevelName}}
                      <span class="block-rail-profile__level">
                        {{dIcon "award"}}
                        <span>{{model.trustLevelName}}</span>
                      </span>
                    {{/if}}
                  </div>
                  {{#if model.secondaryName}}
                    <span
                      class="block-rail-profile__secondary"
                    >{{model.secondaryName}}</span>
                  {{/if}}
                  {{#if model.title}}
                    <span
                      class="block-rail-profile__secondary"
                    >{{model.title}}</span>
                  {{/if}}
                </div>
              </div>

              <div class="block-rail-profile__metadata">
                {{#if model.lastPostedAt}}
                  <div>
                    <span class="desc">{{i18n "last_post"}}</span>
                    {{model.lastPostedAt}}
                  </div>
                {{/if}}
                {{#if model.createdAt}}
                  <div>
                    <span class="desc">{{i18n "joined"}}</span>
                    {{model.createdAt}}
                  </div>
                {{/if}}
              </div>

              {{#if (or model.topics model.posts)}}
                <div class="block-rail-profile__stats">
                  {{#if model.topics}}
                    <span class="block-rail-profile__stat">
                      <span class="block-rail-profile__stat-value">{{model.topics}}</span>
                      <span class="block-rail-profile__stat-label">{{i18n (themePrefix "rail.topics")}}</span>
                    </span>
                  {{/if}}
                  {{#if model.posts}}
                    <span class="block-rail-profile__stat">
                      <span class="block-rail-profile__stat-value">{{model.posts}}</span>
                      <span class="block-rail-profile__stat-label">{{i18n (themePrefix "rail.posts")}}</span>
                    </span>
                  {{/if}}
                </div>
              {{/if}}

              {{#if model.badges.length}}
                <div class="block-rail-profile__badges">
                  {{#each model.badges as |userBadge|}}
                    <UserBadge
                      @badge={{userBadge.badge}}
                      @count={{userBadge.count}}
                      @user={{model.user}}
                    />
                  {{/each}}
                  {{#if model.moreBadgesCount}}
                    <a
                      class="block-rail-profile__more-badges"
                      href={{concat "/u/" model.user.username "/badges"}}
                    >
                      {{i18n "badges.more_badges" count=model.moreBadgesCount}}
                    </a>
                  {{/if}}
                </div>
              {{/if}}
            </section>
          {{/if}}
        </:content>
      </DAsyncContent>
    {{/if}}
  </template>
}
