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

const tableOrderCartItemSchema = mongoose.Schema(
  {
    tableId: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'RestaurantTable',
      required: true,
    },
    tableNumber: {
      type: Number,
      required: true,
      default: 0,
    },
    uuid: {
      type: String,
      required: true,
    },
    addons: [
      {
        type: mongoose.SchemaTypes.ObjectId,
        ref: 'Addons',
        required: false,
      },
    ],
    food: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'Food',
      required: true,
    },
    restaurant: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'Restaurant',
      required: true,
    },
    waiter: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'User',
      required: false,
    },
    quantity: {
      type: Number,
      default: 0,
    },
    variations: {
      type: Array,
      default: [],
    },
    instruction: {
      type: String,
      required: false,
      default: '',
    },
  },
  {
    timestamps: true,
    toJSON: { getters: true },
  }
);

// add plugin that converts mongoose to json
tableOrderCartItemSchema.plugin(toJSON);

/**
 * @typedef TableOrderCartItem
 */
const TableOrderCartItem = mongoose.model('TableOrderCartItem', tableOrderCartItemSchema);

module.exports = TableOrderCartItem;
