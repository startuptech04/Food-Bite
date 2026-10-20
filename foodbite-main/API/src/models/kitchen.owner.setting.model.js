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

const kitchenOwnerSettingSchema = mongoose.Schema(
  {
    // Verification Settings //
    ownerLoginWith: {
      type: String,
      required: false,
      default: 'email_password', // email_password, phone_password, phone_otp, email_otp
    },
    ownerResetPasswordWith: {
      type: String,
      required: false,
      default: 'email_otp', // email_otp, phone_otp
    },
  },
  {
    timestamps: true,
    toJSON: { getters: true },
  }
);

// add plugin that converts mongoose to json & convert to unique slug
kitchenOwnerSettingSchema.plugin(toJSON);

/**
 * @typedef KitchenOwnerSettingSettings
 */
const KitchenOwnerSettingSettings = mongoose.model(
  'KitchenOwnerSettingSettings',
  kitchenOwnerSettingSchema
);

module.exports = KitchenOwnerSettingSettings;
