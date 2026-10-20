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

const kitchenOrderSchema = mongoose.Schema(
  {
    orderFrom: {
      type: String,
      required: true,
      default: 'regular_order', // regular_order, pos_order, table_order
    },
    restaurant: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'Restaurant',
      required: true,
    },
    regularOrder: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'Orders',
      required: false,
    },
    posOrder: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'PosOrTableOrder',
      required: false,
    },
    tableId: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'RestaurantTable',
      required: false,
    },
    cartItemRaw: {
      type: String,
      required: true,
    },
    cookingInstruction: {
      type: String,
      required: false,
    },
    status: {
      type: String,
      default: 'new', // new, preparing, completed,
    },
  },
  {
    timestamps: true,
    toJSON: { getters: true },
  }
);

// add plugin that converts mongoose to json & convert to unique slug
kitchenOrderSchema.plugin(toJSON);
kitchenOrderSchema.plugin(paginate);

/**
 * @typedef KitchenOrder
 */
const KitchenOrder = mongoose.model('KitchenOrder', kitchenOrderSchema);

module.exports = KitchenOrder;
