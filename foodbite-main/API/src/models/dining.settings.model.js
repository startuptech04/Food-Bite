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

const diningSettingSchema = mongoose.Schema(
  {
    restaurantCanCancelRequest: {
      type: Boolean,
      default: false,
    },
    restaurantCanAddOffers: {
      type: Boolean,
      default: false,
    },
    preBookingChargeRequired: {
      type: Boolean,
      default: false,
    },
    guestBooking: {
      type: Boolean,
      required: false,
    },
    commissionPreBooking: {
      type: Number,
      required: true,
      default: 10, // 10
      get: (v) => Number((v / 100).toFixed(2)),
      set: (v) => Math.round(v * 100),
    },
    minBookingCharge: {
      type: Number,
      required: true,
      default: 100, // 10
      get: (v) => Number((v / 100).toFixed(2)),
      set: (v) => Math.round(v * 100),
    },
  },
  {
    timestamps: true,
    toJSON: { getters: true },
  }
);

// add plugin that converts mongoose to json & convert to unique slug
diningSettingSchema.plugin(toJSON);
diningSettingSchema.plugin(paginate);

/**
 * @typedef DiningSetting
 */
const DiningSetting = mongoose.model('DiningSetting', diningSettingSchema);

module.exports = DiningSetting;
