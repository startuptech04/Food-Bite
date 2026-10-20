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

const restaurantFacilitySchema = mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      trim: true,
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
restaurantFacilitySchema.plugin(toJSON);
restaurantFacilitySchema.plugin(paginate);

restaurantFacilitySchema.statics.isNameTaken = async function (name, excludeFacilityId) {
  const facility = await this.findOne({ name, _id: { $ne: excludeFacilityId } });
  return !!facility;
};

/**
 * @typedef RestaurantFacility
 */
const RestaurantFacility = mongoose.model('RestaurantFacility', restaurantFacilitySchema);

module.exports = RestaurantFacility;
