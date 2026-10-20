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

const emailTemplatesSchema = mongoose.Schema(
  {
    slug: {
      type: String,
      required: true,
      unique: true,
    },
    icon: {
      type: String,
      required: true,
    },
    title: {
      type: String,
      required: true,
    },
    content: {
      type: String,
      required: true,
    },
    footerContent: {
      type: String,
      required: true,
    },
    btnLbl: {
      type: String,
      required: false,
    },
    btnUrl: {
      type: String,
      required: false,
    },
    bannerImage: {
      type: String,
      required: false,
    },
    bannerUrl: {
      type: String,
      required: false,
    },
    websiteURL: {
      type: String,
      required: true,
    },
    copyRightContent: {
      type: String,
      required: true,
    },
    htmlContent: {
      type: String,
      required: true,
    },
    aboutPage: {
      type: Boolean,
      required: true,
    },
    privacyPage: {
      type: Boolean,
      required: true,
    },
    termsPage: {
      type: Boolean,
      required: true,
    },
    refundPage: {
      type: Boolean,
      required: true,
    },
    shippingPage: {
      type: Boolean,
      required: true,
    },
    cancellationPage: {
      type: Boolean,
      required: true,
    },
    cookiesPage: {
      type: Boolean,
      required: true,
    },
    helpPage: {
      type: Boolean,
      required: true,
    },
    faqsPage: {
      type: Boolean,
      required: true,
    },
    fbLink: {
      type: Boolean,
      required: true,
    },
    instaLink: {
      type: Boolean,
      required: true,
    },
    xLink: {
      type: Boolean,
      required: true,
    },
    ytLink: {
      type: Boolean,
      required: true,
    },
    llLink: {
      type: Boolean,
      required: true,
    },
    piLink: {
      type: Boolean,
      required: true,
    },
    gpLink: {
      type: Boolean,
      required: true,
    },
    asLink: {
      type: Boolean,
      required: true,
    },
    vmLink: {
      type: Boolean,
      required: true,
    },
    translations: {
      type: Array,
      default: [],
    },
  },
  {
    timestamps: true,
  }
);

// add plugin that converts mongoose to json & convert to unique slug
emailTemplatesSchema.plugin(toJSON);
emailTemplatesSchema.plugin(paginate);

/**
 * @typedef EmailTemplate
 */
const EmailTemplate = mongoose.model('EmailTemplate', emailTemplatesSchema);

module.exports = EmailTemplate;
