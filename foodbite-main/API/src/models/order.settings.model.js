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

const orderSettingSchema = mongoose.Schema(
  {
    deliveryVerification: {
      type: Boolean,
      default: false,
    },
    homeDelivery: {
      type: Boolean,
      default: false,
    },
    takeaway: {
      type: Boolean,
      default: false,
    },
    repeatOrderOption: {
      type: Boolean,
      default: false,
    },
    subscriptionOrder: {
      type: Boolean,
      default: false,
    },
    includeChargesForSubscription: {
      type: Boolean,
      default: false,
    },
    restaurantCanCancelTiffinSubscriptionPackage: {
      type: Boolean,
      default: false,
    },
    userCanCancelTiffinSubscriptionPackage: {
      type: Boolean,
      default: false,
    },
    scheduleDelivery: {
      type: Boolean,
      default: false,
    },
    ratingStyle: {
      type: String,
      default: 'emoji', // emoji // star
    },
    restaurantCanCancelOrder: {
      type: Boolean,
      default: false,
    },
    driverCanCancelOrder: {
      type: Boolean,
      default: false,
    },
    orderConfirmationModel: {
      type: String,
      default: 'restaurant', // restaurant // driver
    },
    timeIntervalForScheduleDelivery: {
      type: Object,
      required: false,
    },
    instantOrder: {
      type: Boolean,
      default: false,
    },
    customerOrderDate: {
      type: Boolean,
      default: false,
    },
    customerCanOrderWithinDays: {
      type: Number,
      required: false,
    },
  },
  {
    timestamps: true,
  }
);

// add plugin that converts mongoose to json & convert to unique slug
orderSettingSchema.plugin(toJSON);

/**
 * @typedef OrderSettings
 */
const OrderSettings = mongoose.model('OrderSettings', orderSettingSchema);

module.exports = OrderSettings;
