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

const userNotificationSchema = mongoose.Schema(
  {
    user: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'User',
      required: false,
    },
    newsletters: {
      type: Boolean,
      default: false,
    },
    promoEmail: {
      type: Boolean,
      default: false,
    },
    promoNotification: {
      type: Boolean,
      default: false,
    },
    promoWhatsApp: {
      type: Boolean,
      default: false,
    },
    socialEmail: {
      type: Boolean,
      default: false,
    },
    socialNotification: {
      type: Boolean,
      default: false,
    },
    orderEmail: {
      type: Boolean,
      default: true,
    },
    orderNotification: {
      type: Boolean,
      default: false,
    },
    orderWhatsApp: {
      type: Boolean,
      default: false,
    },
    importantUpdate: {
      type: Boolean,
      default: true,
    },
  },
  {
    timestamps: true,
  }
);

// add plugin that converts mongoose to json & convert to unique slug
userNotificationSchema.plugin(toJSON);
userNotificationSchema.index({ location: '2dsphere' });

/**
 * @typedef UserNotificationSetting
 */
const UserNotificationSetting = mongoose.model('UserNotificationSetting', userNotificationSchema);

module.exports = UserNotificationSetting;
