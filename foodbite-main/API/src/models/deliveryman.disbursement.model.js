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

const deliverymanDisbursementSchema = mongoose.Schema(
  {
    userId: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'User',
      required: true,
    },
    disbursementId: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'DisbursementData',
      required: true,
    },
    deliverymanPayoutMethod: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'DeliverymanPayoutMethod',
      required: false,
    },
    withdrawalMethod: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'WithdrawalMethod',
      required: false,
    },
    amount: {
      type: Number,
      required: true,
      get: (v) => Number((v / 100).toFixed(2)),
      set: (v) => Math.round(v * 100),
      default: 0,
    },
    status: {
      type: String,
      default: 'created', // created, accepted, rejected
    },
  },
  {
    timestamps: true,
    toJSON: { getters: true },
  }
);

// add plugin that converts mongoose to json & convert to unique slug
deliverymanDisbursementSchema.plugin(toJSON);
deliverymanDisbursementSchema.plugin(paginate);

/**
 * @typedef DeliverymanDisbursement
 */
const DeliverymanDisbursement = mongoose.model(
  'DeliverymanDisbursement',
  deliverymanDisbursementSchema
);

module.exports = DeliverymanDisbursement;
