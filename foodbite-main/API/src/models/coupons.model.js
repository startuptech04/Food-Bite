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

const couponSchema = mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      trim: true,
    },
    city: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'City',
      required: true,
    },
    location: {
      type: {
        type: String, // Don't do `{ location: { type: String } }`
        enum: ['Point'], // 'location.type' must be 'Point'
        default: 'Point',
      },
      coordinates: {
        type: [Number],
        required: true,
      },
    },
    couponType: {
      type: String,
      required: true,
      default: 'default', // default // restaurant // freedelivery // firstorder // loyality // bogo
    },
    allRestaurants: {
      type: Boolean,
      default: false,
    },
    restaurant: [
      {
        type: mongoose.SchemaTypes.ObjectId,
        ref: 'Restaurant',
        required: false,
      },
    ],
    allUsers: {
      type: Boolean,
      default: false,
    },
    user: [
      {
        type: mongoose.SchemaTypes.ObjectId,
        ref: 'User',
        required: false,
      },
    ],
    code: {
      type: String,
      required: true,
    },
    limitSameUser: {
      type: Number,
      required: false,
      get: (v) => Number((v / 100).toFixed(2)),
      set: (v) => Math.round(v * 100),
    },
    start: {
      type: Date,
      required: true,
    },
    expires: {
      type: Date,
      required: true,
    },
    discountType: {
      type: String,
      required: false, // amount // percentage
      default: 'amount',
    },
    minDiscount: {
      type: Number,
      required: false,
      get: (v) => Number((v / 100).toFixed(2)),
      set: (v) => Math.round(v * 100),
      default: 0,
    },
    maxDiscount: {
      type: Number,
      required: false,
      get: (v) => Number((v / 100).toFixed(2)),
      set: (v) => Math.round(v * 100),
      default: 0,
    },
    minCartTotal: {
      type: Number,
      required: false,
      get: (v) => Number((v / 100).toFixed(2)),
      set: (v) => Math.round(v * 100),
      default: 0,
    },
    loyalityPoints: {
      type: Number,
      required: false,
      get: (v) => Number((v / 100).toFixed(2)),
      set: (v) => Math.round(v * 100),
      default: 0,
    },
    createdBy: {
      type: String,
      required: true,
      default: 'admin', // admin // vendor // vendorOutlet // cityMaster
    },
    createdById: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'User',
      required: false,
    },
    translations: {
      type: Array,
      default: [],
    },
    status: {
      type: String,
      default: 'hold', // hold,live,hide,requested
    },
  },
  {
    timestamps: true,
    toJSON: { getters: true },
  }
);

// add plugin that converts mongoose to json & convert to unique slug
couponSchema.plugin(toJSON);
couponSchema.plugin(paginate);
couponSchema.index({ location: '2dsphere' });

/**
 * @typedef Coupon
 */
const Coupon = mongoose.model('Coupon', couponSchema);

module.exports = Coupon;
