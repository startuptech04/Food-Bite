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

const landingPageSchema = mongoose.Schema(
  {
    heroContent: {
      type: Object,
      required: false,
    },
    appFeatureContent: {
      type: Object,
      required: false,
    },
    featureContent: {
      type: Object,
      required: false,
    },
    serviceContent: {
      type: Object,
      required: false,
    },
    faqContent: {
      type: Object,
      required: false,
    },
    reviewContent: {
      type: Object,
      required: false,
    },
    scanQrContent: {
      type: Object,
      required: false,
    },
  },
  {
    timestamps: true,
  }
);

// add plugin that converts mongoose to json & convert to unique slug
landingPageSchema.plugin(toJSON);

/**
 * @typedef LandingPage
 */
const LandingPage = mongoose.model('LandingPage', landingPageSchema);

module.exports = LandingPage;
