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

const driverNewOrderStatusSchema = mongoose.Schema(
  {
    orderId: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'Orders',
      required: true,
    },
    driver: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'User',
      required: true,
    },
    restaurant: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'Restaurant',
      required: true,
    },
    deliveryAddressRaw: {
      type: String,
      required: false,
    },
    driverOrderStatus: {
      type: String,
      default: 'ideal', // ideal, accepted, driver_reached_restaurant, driver_pickpup_order, driver_reached_customer, rejected, cancelled, delivered, accepted_another
      required: false,
    },
    orderCancellation: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'OrderCancellationReason',
      required: false,
    },
    orderFrom: {
      type: String,
      default: 'manually', // manually, automatically
      required: false,
    },
    earning: {
      type: Number,
      required: false,
      get: (v) => Number((v / 100).toFixed(2)),
      set: (v) => Math.round(v * 100),
      default: 0,
    },
    tipAmount: {
      type: Number,
      required: false,
      get: (v) => Number((v / 100).toFixed(2)),
      set: (v) => Math.round(v * 100),
      default: 0,
    },
    incentiveAmount: {
      type: Number,
      required: false,
      get: (v) => Number((v / 100).toFixed(2)),
      set: (v) => Math.round(v * 100),
      default: 0,
    },
    extraEarningOnShiftAmount: {
      type: Number,
      required: false,
      get: (v) => Number((v / 100).toFixed(2)),
      set: (v) => Math.round(v * 100),
      default: 0,
    },
    acceptedAt: {
      type: Date,
      required: false,
    },
    deliveredAt: {
      type: Date,
      required: false,
    },
  },
  {
    timestamps: true,
    toJSON: { getters: true },
  }
);

// add plugin that converts mongoose to json & convert to unique slug
driverNewOrderStatusSchema.plugin(toJSON);

/**
 * @typedef DriverNewOrderStatus
 */
const DriverNewOrderStatus = mongoose.model('DriverNewOrderStatus', driverNewOrderStatusSchema);

module.exports = DriverNewOrderStatus;
