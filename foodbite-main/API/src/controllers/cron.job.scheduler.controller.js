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

const catchAsync = require('../utils/catchAsync');
const pick = require('../utils/pick');
const { cronJobSchedulerService } = require('../services');

const startScheduler = catchAsync(async (req, res) => {
  cronJobSchedulerService.startCronJobScheduler.startCronJob();
  res.send({ success: true });
});

const stopScheduler = catchAsync(async (req, res) => {
  cronJobSchedulerService.stopAllCronJobsScheduler.stopCronJob();
  res.send({ success: true });
});

const getSchedulerInfo = catchAsync(async (req, res) => {
  const options = pick(req.query, ['sortBy', 'limit', 'page']);
  const result = await cronJobSchedulerService.getSchedulerInfo(options);
  res.send(result);
});

module.exports = {
  startScheduler,
  stopScheduler,
  getSchedulerInfo,
};
