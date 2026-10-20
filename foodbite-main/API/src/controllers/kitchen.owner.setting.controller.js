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
const { kitchenOwnerSettingService } = require('../services');

const create = catchAsync(async (req, res) => {
  const result = await kitchenOwnerSettingService.createSettings(req.body);
  res.send(result);
});

const get = catchAsync(async (req, res) => {
  const settings = await kitchenOwnerSettingService.getSettings();
  res.send({ settings });
});

const update = catchAsync(async (req, res) => {
  const result = await kitchenOwnerSettingService.updateSettings(req.params.settingId, req.body);
  res.send(result);
});

module.exports = {
  create,
  get,
  update,
};
