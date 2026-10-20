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

const orderDeliveryProofSchema = mongoose.Schema(
  {
    orderId: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'Orders',
      required: true,
    },
    pickup: {
      type: String,
      default: 'none',
      required: false,
    },
    dropup: {
      type: String,
      default: 'none',
      required: false,
    },
  },
  {
    timestamps: true,
    toJSON: { getters: true },
  }
);

// add plugin that converts mongoose to json & convert to unique slug
orderDeliveryProofSchema.plugin(toJSON);

/**
 * @typedef OrderDeliveryProof
 */
const OrderDeliveryProof = mongoose.model('OrderDeliveryProof', orderDeliveryProofSchema);

module.exports = OrderDeliveryProof;
