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

const adminExpenseSchema = mongoose.Schema(
  {
    expenseType: {
      type: String,
      required: true,
      default: 'other', // coupon, delivery_charge, referral, wallet_bonus, loyalty_points, dining_booking_coupon, customer_wallet_credit, it_support_service, ads, employee_expenses, outsource, payment_gateway_charge, other
    },
    coupon: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'Coupon',
      required: false,
    },
    diningCoupon: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'DiningCoupon',
      required: false,
    },
    diningBooking: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'DiningBooking',
      required: false,
    },
    order: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'Orders',
      required: false,
    },
    user: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'User',
      required: false,
    },
    amount: {
      type: Number,
      required: false,
      get: (v) => Number((v / 100).toFixed(2)),
      set: (v) => Math.round(v * 100),
      default: 0,
    },
  },
  {
    timestamps: true,
    toJSON: { getters: true },
  }
);

// add plugin that converts mongoose to json & convert to unique slug
adminExpenseSchema.plugin(toJSON);
adminExpenseSchema.plugin(paginate);

/**
 * @typedef AdminExpense
 */
const AdminExpense = mongoose.model('AdminExpense', adminExpenseSchema);

module.exports = AdminExpense;
