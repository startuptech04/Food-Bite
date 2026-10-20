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
const { userNotificationSettingService } = require('../services');

const getNotificationSettings = catchAsync(async (req, res) => {
  const { id } = req.params;
  const result = await userNotificationSettingService.getNotificationSettings(id);
  res.send(result);
});

const updateNotificationSetting = catchAsync(async (req, res) => {
  const { id } = req.params;
  const result = await userNotificationSettingService.updateNotificationSetting(id, req.body);
  res.send(result);
});

module.exports = {
  getNotificationSettings,
  updateNotificationSetting,
};
