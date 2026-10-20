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

const joiningFormSchema = mongoose.Schema(
  {
    restaurantForm: {
      type: Array,
      default: [],
    },
    deliverymanForm: {
      type: Array,
      default: [],
    },
  },
  {
    timestamps: true,
    toJSON: { getters: true },
  }
);

// add plugin that converts mongoose to json & convert to unique slug
joiningFormSchema.plugin(toJSON);

/**
 * @typedef JoiningForm
 */
const JoiningForm = mongoose.model('JoiningForm', joiningFormSchema);

module.exports = JoiningForm;
