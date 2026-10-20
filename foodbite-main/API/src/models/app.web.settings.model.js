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

const appWebSettingSchema = mongoose.Schema(
  {
    showPopularFood: {
      type: Boolean,
      default: true,
    },
    showMostReviewedFood: {
      type: Boolean,
      default: true,
    },
    showTodaysTrendingFood: {
      type: Boolean,
      default: true,
    },
    showPopularRestaurant: {
      type: Boolean,
      default: true,
    },
    showNewRestaurant: {
      type: Boolean,
      default: true,
    },
    showTiffinSubscriptionPackages: {
      type: Boolean,
      default: true,
    },
    showPopularDiningRestaurant: {
      type: Boolean,
      default: true,
    },
    showNewDiningRestaurant: {
      type: Boolean,
      default: true,
    },

    /// User App Info //
    userAndroidForceUpdateVersion: {
      type: String,
      required: false,
    },
    userAndroidUpdateUrl: {
      type: String,
      required: false,
    },
    useriOSForceUpdateVersion: {
      type: String,
      required: false,
    },
    useriOSUpdateUrl: {
      type: String,
      required: false,
    },
    /// User App Info //

    /// Vendor App Info //
    vendorAndroidForceUpdateVersion: {
      type: String,
      required: false,
    },
    vendorAndroidUpdateUrl: {
      type: String,
      required: false,
    },
    vendoriOSForceUpdateVersion: {
      type: String,
      required: false,
    },
    vendoriOSUpdateUrl: {
      type: String,
      required: false,
    },
    /// Vendor App Info //

    /// DeliveryMan App Info //
    deliveryManAndroidForceUpdateVersion: {
      type: String,
      required: false,
    },
    deliveryManAndroidUpdateUrl: {
      type: String,
      required: false,
    },
    deliveryManiOSForceUpdateVersion: {
      type: String,
      required: false,
    },
    deliveryManiOSUpdateUrl: {
      type: String,
      required: false,
    },
    /// DeliveryMan App Info //

    // Waiter App Info //
    waiterAndroidForceUpdateVersion: {
      type: String,
      required: false,
    },
    waiterAndroidUpdateUrl: {
      type: String,
      required: false,
    },
    waiteriOSForceUpdateVersion: {
      type: String,
      required: false,
    },
    waiteriOSUpdateUrl: {
      type: String,
      required: false,
    },
    // Waiter App Info //

    // Kitchen App Info //
    kitchenAndroidForceUpdateVersion: {
      type: String,
      required: false,
    },
    kitchenAndroidUpdateUrl: {
      type: String,
      required: false,
    },
    kitcheniOSForceUpdateVersion: {
      type: String,
      required: false,
    },
    kitcheniOSUpdateUrl: {
      type: String,
      required: false,
    },
    // Kitchen App Info //
  },
  {
    timestamps: true,
  }
);

// add plugin that converts mongoose to json & convert to unique slug
appWebSettingSchema.plugin(toJSON);
appWebSettingSchema.plugin(paginate);

/**
 * @typedef AppWebSetting
 */
const AppWebSetting = mongoose.model('AppWebSetting', appWebSettingSchema);

module.exports = AppWebSetting;
