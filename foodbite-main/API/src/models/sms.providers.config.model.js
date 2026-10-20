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

const smsProvidersConfigSchema = mongoose.Schema(
  {
    slug: {
      type: String,
      unique: true,
    },
    credentials: {
      type: Object,
      required: true,
    },
    isDefault: {
      type: Boolean,
      default: false,
    },
    template: {
      type: Array,
      default: [],
    },
    status: {
      type: Boolean,
      default: true,
    },
  },
  {
    timestamps: true,
  }
);

// add plugin that converts mongoose to json & convert to unique slug
smsProvidersConfigSchema.plugin(toJSON);

/**
 * @typedef SmsProviderConfig
 */
const SmsProviderConfig = mongoose.model('SmsProviderConfig', smsProvidersConfigSchema);

module.exports = SmsProviderConfig;
