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
  diningSettingsService,
  diningCancellationReasonService,
  diningCategoryService,
  diningNoticeService,
} = require('../services');

const create = catchAsync(async (req, res) => {
  const result = await diningSettingsService.createDiningSettings(req.body);
  res.send(result);
});

const update = catchAsync(async (req, res) => {
  const result = await diningSettingsService.updateDiningSetting(req.params.id, req.body);
  res.send(result);
});

const get = catchAsync(async (req, res) => {
  const options = pick(req.query, ['sortBy', 'limit', 'page']);
  const settings = await diningSettingsService.getDiningSetting();
  const reasons = await diningCancellationReasonService.getDiningCancallationListAdmin(options);
  const categories = await diningCategoryService.getAllCategoryAdmin(options);
  const notice = await diningNoticeService.getList(options);
  res.send({ settings, reasons, categories, notice });
});

const getDiningSettingForVendor = catchAsync(async (req, res) => {
  const result = await diningSettingsService.getDiningSettingForVendor();
  res.send(result);
});

module.exports = {
  create,
  update,
  get,
  getDiningSettingForVendor,
};
