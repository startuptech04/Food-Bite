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

const socialSigninSchema = mongoose.Schema(
  {
    appleSignin: {
      type: Boolean,
      default: true,
    },
    googleSignin: {
      type: Boolean,
      default: true,
    },
    facebookSignin: {
      type: Boolean,
      default: true,
    },
    configCredsRaw: {
      google_client_id: {
        type: String,
        default: '',
        required: false,
      },
      google_server_id: {
        type: String,
        default: '',
        required: false,
      },
    },
  },
  {
    timestamps: true,
  }
);

// add plugin that converts mongoose to json & convert to unique slug
socialSigninSchema.plugin(toJSON);

/**
 * @typedef SocialSignin
 */
const SocialSignin = mongoose.model('SocialSignin', socialSigninSchema);

module.exports = SocialSignin;
