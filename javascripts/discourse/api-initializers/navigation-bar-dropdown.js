import { apiInitializer } from "discourse/lib/api";

// Core collapses the discovery filters ("latest", "top", …) into a single button
// on mobile and opens them in a float-kit bottom sheet. That sheet is owned by
// core: it re-enters, and on touch screens it flashed and flickered back open
// while the theme could not reach its internals. The theme already lays
// `#navigation-bar` out as a single horizontally scrollable row on mobile, so
// keeping the pills inline gives the same filters one tap away and removes the
// sheet (and its flicker) entirely. Reversible: drop this initializer.
export default apiInitializer((api) => {
  api.registerValueTransformer?.("navigation-bar-dropdown-mode", () => false);
});
