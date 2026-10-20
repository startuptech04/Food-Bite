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
const { toJSON, slugGenerator, paginate } = require('./plugins');

const cuisineSchema = mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      trim: true,
    },
    image: {
      type: String,
      required: true,
    },
    slug: {
      type: 'String',
      source: 'name',
      unique: true,
    },
    translations: {
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
cuisineSchema.plugin(toJSON);
cuisineSchema.plugin(slugGenerator);
cuisineSchema.plugin(paginate);

cuisineSchema.statics.isNameTaken = async function (name, excludeCuisineId) {
  const cuisine = await this.findOne({ name, _id: { $ne: excludeCuisineId } });
  return !!cuisine;
};

/**
 * @typedef Cuisine
 */
const Cuisine = mongoose.model('Cuisine', cuisineSchema);

module.exports = Cuisine;
