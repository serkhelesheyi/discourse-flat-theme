export default <template>
  <div class="user-card-metadata-outlet metadata__trust-level" ...attributes>
    <span class="desc">{{i18n (theme-prefix "user_card.trust_level")}}</span>
    <span class="user-card-trust-level-value">{{@outletArgs.user.trust_level}}/4</span>
  </div>
</template>;
