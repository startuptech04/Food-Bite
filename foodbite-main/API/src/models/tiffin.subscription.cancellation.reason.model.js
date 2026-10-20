/**
 * FoodBite – Multi Restaurant Food Delivery App
 * (NodeJS, MongoDB, Angular & Flutter)
 *
 * Copyright © 2026 Elitecanyon InfoTech (https://www.elitecanyon.com/)
 * Licensed under the Envato Market License.
 *
 * Unauthorized redistribution, resale, or publication
 * of this source code on GitHub or any public repository
 * is strictly prohibited.
 *
 * Ownership Fingerprint:
 * FB|RJ|2026|ENVATO|FOODBITE|NODE
 */

const mongoose = require('mongoose');
const { toJSON, paginate } = require('./plugins');

const tiffinSubscriptionCancellationReasonSchema = mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      trim: true,
    },
    type: {
      type: String,
      required: true,
      trim: true,
    },
    translations: {
      type: Array,
      default: [],
    },
    status: {
      type: Boolean,
      default: true,
    },
  },
  {
    timestamps: true,
  }
);

// add plugin that converts mongoose to json & convert to unique slug
tiffinSubscriptionCancellationReasonSchema.plugin(toJSON);
tiffinSubscriptionCancellationReasonSchema.plugin(paginate);

tiffinSubscriptionCancellationReasonSchema.statics.isNameTaken = async function (
  name,
  excludeReasonId
) {
  const reason = await this.findOne({ name, _id: { $ne: excludeReasonId } });
  return !!reason;
};

/**
 * @typedef TiffinSubscriptionCancellationReason
 */
const TiffinSubscriptionCancellationReason = mongoose.model(
  'TiffinSubscriptionCancellationReason',
  tiffinSubscriptionCancellationReasonSchema
);

module.exports = TiffinSubscriptionCancellationReason;
