import ActivitySheet from "./activity-sheet.mjs";

/**
 * Sheet for the damage activity.
 */
export default class DamageSheet extends ActivitySheet {

  /** @inheritDoc */
  static DEFAULT_OPTIONS = {
    classes: ["damage-activity"]
  };

  /* -------------------------------------------- */

  /** @inheritDoc */
  static PARTS = {
    ...super.PARTS,
    effect: {
      template: "systems/las-torres-malditas/templates/activity/damage-effect.hbs",
      templates: [
        ...super.PARTS.effect.templates,
        "systems/las-torres-malditas/templates/activity/parts/damage-damage.hbs",
        "systems/las-torres-malditas/templates/activity/parts/damage-part.hbs",
        "systems/las-torres-malditas/templates/activity/parts/damage-parts.hbs"
      ]
    }
  };
}
