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
const {
  restaurantSettingsService,
  restaurantFoodLicenseService,
  restaurantNoticeService,
} = require('../services');

const create = catchAsync(async (req, res) => {
  const result = await restaurantSettingsService.createSettings(req.body);
  res.send(result);
});

const get = catchAsync(async (req, res) => {
  const settings = await restaurantSettingsService.getSettings();
  const options = pick(req.query, ['sortBy', 'limit', 'page']);
  const license = await restaurantFoodLicenseService.getRestaurantLicenseListAdmin(options);
  const notice = await restaurantNoticeService.getList(options);
  res.send({ settings, license, notice });
});

const update = catchAsync(async (req, res) => {
  const result = await restaurantSettingsService.updateSettings(req.params.settingId, req.body);
  res.send(result);
});

module.exports = {
  create,
  get,
  update,
};
