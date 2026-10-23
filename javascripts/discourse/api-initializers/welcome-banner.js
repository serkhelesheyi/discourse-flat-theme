import { apiInitializer } from "discourse/lib/api";

export default apiInitializer((api) => {
  // The flat theme's hero owns the discovery search surface, so the core welcome
  // banner is suppressed. Hiding it with CSS was not enough: the component still
  // mounts, and its viewport modifier sets `search.welcomeBannerSearchInViewport`
  // to true before its first measurement corrects it. The header reads that flag,
  // so the search icon vanished and came back on every first load. Asking core
  // not to render the banner at all leaves the flag alone.
  api.registerValueTransformer?.(
    "welcome-banner-display-for-route",
    () => false
  );
});
