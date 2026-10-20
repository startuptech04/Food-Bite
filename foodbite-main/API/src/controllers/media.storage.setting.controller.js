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
const { mediaStorageSettingService } = require('../services');

const create = catchAsync(async (req, res) => {
  const result = await mediaStorageSettingService.createMediaStorageSetting(req.body);
  res.send(result);
});

const update = catchAsync(async (req, res) => {
  const result = await mediaStorageSettingService.updateMediaStorageSetting(
    req.params.id,
    req.body
  );
  res.send(result);
});

const get = catchAsync(async (req, res) => {
  const result = await mediaStorageSettingService.getMediaStorageSetting();
  res.send(result);
});

module.exports = {
  create,
  update,
  get,
};
