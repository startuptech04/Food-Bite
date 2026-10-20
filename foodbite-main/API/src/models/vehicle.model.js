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

const vehicleSchema = mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
    },
    extraCharge: {
      type: Number,
      required: true,
    },
    minimumCoverage: {
      type: Number,
      required: true,
    },
    maximumCoverage: {
      type: Number,
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
vehicleSchema.plugin(toJSON);
vehicleSchema.plugin(paginate);

vehicleSchema.statics.isNameTaken = async function (name, excludeVehicleId) {
  const vehicle = await this.findOne({ name, _id: { $ne: excludeVehicleId } });
  return !!vehicle;
};

/**
 * @typedef Vehicle
 */
const Vehicle = mongoose.model('Vehicle', vehicleSchema);

module.exports = Vehicle;
