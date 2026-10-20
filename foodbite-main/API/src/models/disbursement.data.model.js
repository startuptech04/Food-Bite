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

const disbursementDataSchema = mongoose.Schema(
  {
    disbursementNo: {
      type: Number,
      required: true,
    },
    generatedTime: {
      type: String,
      required: true,
    },
    totalAmount: {
      type: Number,
      required: false,
      get: (v) => Number((v / 100).toFixed(2)),
      set: (v) => Math.round(v * 100),
      default: 0,
    },
    cronJobDate: {
      type: String,
      required: true,
    },
    disbursementType: {
      type: String,
      required: true,
      default: 'restaurant', // restaurant, deliveryman
    },
    status: {
      type: String,
      default: 'pending', // pending, completed, partially_completed, cancelled
    },
  },
  {
    timestamps: true,
    toJSON: { getters: true },
  }
);

// add plugin that converts mongoose to json & convert to unique slug
disbursementDataSchema.plugin(toJSON);
disbursementDataSchema.plugin(paginate);

/**
 * @typedef DisbursementData
 */
const DisbursementData = mongoose.model('DisbursementData', disbursementDataSchema);

module.exports = DisbursementData;
