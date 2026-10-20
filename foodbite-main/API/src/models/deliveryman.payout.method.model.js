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

const deliverymanPayoutMethodSchema = mongoose.Schema(
  {
    method: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'WithdrawalMethod',
      required: true,
    },
    deliveryman: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'User',
      required: true,
    },
    formElement: {
      type: Array,
      default: [],
    },
    isDefault: {
      type: Boolean,
      default: false,
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
deliverymanPayoutMethodSchema.plugin(toJSON);
deliverymanPayoutMethodSchema.plugin(paginate);

/**
 * @typedef DeliverymanPayoutMethod
 */
const DeliverymanPayoutMethod = mongoose.model(
  'DeliverymanPayoutMethod',
  deliverymanPayoutMethodSchema
);

module.exports = DeliverymanPayoutMethod;
