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

const foodampaignRequestSchema = mongoose.Schema(
  {
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
    campaign: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'FoodCampaign',
      required: true,
    },
    status: {
      type: String,
      default: 'requested',
    },
  },
  {
    timestamps: true,
  }
);

// add plugin that converts mongoose to json & convert to unique slug
foodampaignRequestSchema.plugin(toJSON);
foodampaignRequestSchema.plugin(paginate);

/**
 * @typedef FoodCampaignRequest
 */
const FoodCampaignRequest = mongoose.model('FoodCampaignRequest', foodampaignRequestSchema);

module.exports = FoodCampaignRequest;
