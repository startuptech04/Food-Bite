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

const otpVerificationSchema = mongoose.Schema(
  {
    provider: {
      type: String,
      required: true,
    },
    otp: {
      type: String,
      required: true,
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
otpVerificationSchema.plugin(toJSON);
otpVerificationSchema.plugin(paginate);

/**
 * @typedef OtpVerification
 */
const OtpVerification = mongoose.model('OtpVerification', otpVerificationSchema);

module.exports = OtpVerification;
