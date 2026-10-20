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

const cronJobSchedulerSchema = mongoose.Schema(
  {
    jobName: {
      type: String,
      required: true,
      trim: true,
    },
    startTime: { type: Date, required: true },
    endTime: { type: Date },
    status: { type: String, enum: ['success', 'failure'], required: true },
    errorMessage: { type: String },
  },
  {
    timestamps: true,
  }
);

// add plugin that converts mongoose to json & convert to unique slug
cronJobSchedulerSchema.plugin(toJSON);

/**
 * @typedef CronJobScheduler
 */
const CronJobScheduler = mongoose.model('CronJobScheduler', cronJobSchedulerSchema);

module.exports = CronJobScheduler;
