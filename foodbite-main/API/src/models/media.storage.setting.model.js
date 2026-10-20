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

const mediaStorageSettingSchema = mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      trim: true,
    },
    imagePath: {
      type: String,
      trim: true,
      default: '',
    },
    credentials: {
      type: Object,
      required: true,
    },
  },
  {
    timestamps: true,
  }
);

// add plugin that converts mongoose to json & convert to unique slug
mediaStorageSettingSchema.plugin(toJSON);
mediaStorageSettingSchema.plugin(paginate);

/**
 * @typedef MediaStorageSetting
 */
const MediaStorageSetting = mongoose.model('MediaStorageSetting', mediaStorageSettingSchema);

module.exports = MediaStorageSetting;
