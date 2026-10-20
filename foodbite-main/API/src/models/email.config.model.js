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

const EmailConfigSchema = mongoose.Schema(
  {
    smtpHost: {
      type: String,
      required: true,
      trim: true,
    },
    smtpPort: {
      type: Number,
      required: true,
    },
    smtpUsername: {
      type: String,
      required: true,
      trim: true,
    },
    smtpPassword: {
      type: String,
      required: true,
      trim: true,
    },
    smtpFromEmail: {
      type: String,
      required: true,
      trim: true,
    },
    smtpFromName: {
      type: String,
      required: true,
      trim: true,
    },
    smtpDriver: {
      type: String,
      required: true,
      trim: true,
    },
    smtpEncryption: {
      type: String,
      required: true,
      trim: true,
    },
    mediaUrls: {
      type: Object,
      required: false,
    },
  },
  {
    timestamps: true,
  }
);

// add plugin that converts mongoose to json & convert to unique slug
EmailConfigSchema.plugin(toJSON);
EmailConfigSchema.plugin(paginate);

/**
 * @typedef EmailConfig
 */
const EmailConfig = mongoose.model('EmailConfig', EmailConfigSchema);

module.exports = EmailConfig;
