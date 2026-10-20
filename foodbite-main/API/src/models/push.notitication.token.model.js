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

const pushNotificationTokenSchema = mongoose.Schema(
  {
    user: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'User',
      required: false, // user id
    },
    token: {
      type: String,
      required: true, // push notification token
    },
    deviceId: {
      type: String,
      required: true, // unique device id
    },
    deviceType: {
      type: String,
      required: true, // android // ios
    },
  },
  {
    timestamps: true,
  }
);

// add plugin that converts mongoose to json & convert to unique slug
pushNotificationTokenSchema.plugin(toJSON);

/**
 * @typedef PushNotificationToken
 */
const PushNotificationToken = mongoose.model('PushNotificationToken', pushNotificationTokenSchema);

module.exports = PushNotificationToken;
