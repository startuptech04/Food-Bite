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

const otpWebVerificationSchema = mongoose.Schema(
  {
    provider: {
      type: String,
      required: true,
    },
    redirectUrl: {
      type: String,
      required: true,
    },
    kind: {
      type: String,
      required: true,
    },
    token: {
      type: String,
      default: '',
    },
    mode: {
      type: String,
      required: true,
    },
    locale: {
      type: String,
      required: true,
    },
    status: {
      type: Boolean,
      default: false,
    },
  },
  {
    timestamps: true,
  }
);

// add plugin that converts mongoose to json & convert to unique slug
otpWebVerificationSchema.plugin(toJSON);
otpWebVerificationSchema.plugin(paginate);

/**
 * @typedef OtpWebVerification
 */
const OtpWebVerification = mongoose.model('OtpWebVerification', otpWebVerificationSchema);

module.exports = OtpWebVerification;
