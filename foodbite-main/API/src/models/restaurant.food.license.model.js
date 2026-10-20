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

const restaurantFoodLicenseSchema = mongoose.Schema(
  {
    image: {
      type: String,
      required: true,
    },
    name: {
      type: String,
      required: true,
    },
    website: {
      type: String,
      required: true,
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
restaurantFoodLicenseSchema.plugin(toJSON);
restaurantFoodLicenseSchema.plugin(paginate);

restaurantFoodLicenseSchema.statics.isNameTaken = async function (
  name,
  excludeRestaurantFoodLicenseId
) {
  const license = await this.findOne({ name, _id: { $ne: excludeRestaurantFoodLicenseId } });
  return !!license;
};

/**
 * @typedef RestaurantFoodLicense
 */
const RestaurantFoodLicense = mongoose.model('RestaurantFoodLicense', restaurantFoodLicenseSchema);

module.exports = RestaurantFoodLicense;
