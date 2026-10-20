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

const userAddressSchema = mongoose.Schema(
  {
    user: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'User',
      required: false,
    },
    title: {
      type: Number,
      required: true,
      default: 0, // 0 = home // 1 = work // 2 = hotel // 3 = other
    },
    receiverName: {
      type: String,
      required: true,
    },
    countryCode: {
      type: Number,
      required: true,
    },
    receiverContact: {
      type: String,
      required: true,
    },
    flatHouse: {
      type: String,
      required: true,
    },
    locality: {
      type: String,
      required: true,
    },
    landmark: {
      type: String,
      required: false,
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
userAddressSchema.plugin(toJSON);
userAddressSchema.index({ location: '2dsphere' });

/**
 * @typedef UserAddress
 */
const UserAddress = mongoose.model('UserAddress', userAddressSchema);

module.exports = UserAddress;
