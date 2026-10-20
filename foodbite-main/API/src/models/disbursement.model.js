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

const disbursementSchema = mongoose.Schema(
  {
    type: {
      type: String,
      required: false,
      default: 'auto', // manual or auto
    },
    restaurant: {
      type: Object,
      required: false,
    },
    driver: {
      type: Object,
      required: false,
    },
  },
  {
    timestamps: true,
  }
);

// add plugin that converts mongoose to json & convert to unique slug
disbursementSchema.plugin(toJSON);

/**
 * @typedef Disbursement
 */
const Disbursement = mongoose.model('Disbursement', disbursementSchema);

module.exports = Disbursement;
