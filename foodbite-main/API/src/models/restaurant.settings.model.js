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
const { toJSON } = require('./plugins');

const restaurantSettingsSchema = mongoose.Schema(
  {
    // Verification Settings //
    restaurantLoginWith: {
      type: String,
      required: false,
      default: 'email_password', // email_password, phone_password, phone_otp, email_otp
    },
    restaurantResetPasswordWith: {
      type: String,
      required: false,
      default: 'email_otp', // email_otp, phone_otp
    },
    selfRegistration: {
      type: Boolean,
      required: false,
      default: false,
    },
    // Verification Settings //

    // Cash In Hand //
    cashInHand: {
      type: Boolean,
      required: false,
      default: false,
    },
    minCashInHand: {
      type: Number,
      required: false,
      default: 0,
    },
    maxCashInHand: {
      type: Number,
      required: false,
      default: 0,
    },
    // Cash In Hand //

    driverPickup: {
      type: Boolean,
      required: false,
      default: true,
    },
    canInitiateChat: {
      type: Boolean,
      required: false,
      default: false,
    },
    canInitiateCall: {
      type: Boolean,
      required: false,
      default: true,
    },

    // Packages Charges
    havePackagingCharges: {
      type: Boolean,
      required: false,
      default: false,
    },
    packagingCharges: {
      type: Number,
      required: false,
      default: 0,
    },
    includePackagesChargesInTax: {
      type: Boolean,
      required: false,
      default: false,
    },
    packagingChargesTax: { type: Number, required: false, default: 0 },
  },
  {
    timestamps: true,
  }
);

// add plugin that converts mongoose to json & convert to unique slug
restaurantSettingsSchema.plugin(toJSON);

/**
 * @typedef RestaurantSettings
 */
const RestaurantSettings = mongoose.model('RestaurantSettings', restaurantSettingsSchema);

module.exports = RestaurantSettings;
