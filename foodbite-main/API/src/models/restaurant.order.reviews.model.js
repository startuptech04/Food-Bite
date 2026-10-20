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

const restaurantOrderReviewSchema = mongoose.Schema(
  {
    user: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'User',
      required: true,
    },
    orders: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'Orders',
      required: false,
    },
    restaurant: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'Restaurant',
      required: true,
    },
    ratingCount: {
      type: Number,
      required: true,
    },
    messages: [
      {
        type: mongoose.SchemaTypes.ObjectId,
        ref: 'OrderRatingMessages',
        required: false,
      },
    ],
    images: {
      type: Array,
      default: [],
    },
    shortReview: {
      type: String,
      required: false,
      trim: true,
    },
  },
  {
    timestamps: true,
  }
);

// add plugin that converts mongoose to json & convert to unique slug
restaurantOrderReviewSchema.plugin(toJSON);

/**
 * @typedef RestaurantOrderReview
 */
const RestaurantOrderReview = mongoose.model('RestaurantOrderReview', restaurantOrderReviewSchema);

module.exports = RestaurantOrderReview;
