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

const diningBookingRefundRequestReasonSchema = mongoose.Schema(
  {
    name: {
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
diningBookingRefundRequestReasonSchema.plugin(toJSON);
diningBookingRefundRequestReasonSchema.plugin(paginate);

diningBookingRefundRequestReasonSchema.statics.isNameTaken = async function (
  name,
  excludeReasonId
) {
  const reason = await this.findOne({ name, _id: { $ne: excludeReasonId } });
  return !!reason;
};

/**
 * @typedef DiningBookingRefundRequestReason
 */
const DiningBookingRefundRequestReason = mongoose.model(
  'DiningBookingRefundRequestReason',
  diningBookingRefundRequestReasonSchema
);

module.exports = DiningBookingRefundRequestReason;
