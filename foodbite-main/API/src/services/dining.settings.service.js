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

const { status: httpStatus } = require('http-status');
const { DiningSetting } = require('../models');
const ApiError = require('../utils/ApiError');

const createDiningSettings = async (param) => {
  if ((await DiningSetting.countDocuments()) > 0) {
    throw new ApiError(httpStatus.BAD_REQUEST, 'Already exist');
  }
  const details = await DiningSetting.create(param);
  return { id: details.id, success: true };
};

const getDiningSetting = async () => {
  return DiningSetting.findOne();
};

const updateDiningSetting = async (slug, param) => {
  const diningSetting = await getDiningSetting(slug);

  Object.assign(diningSetting, param);
  await diningSetting.save();
  return { success: true };
};

const getDiningSettingForVendor = async () => {
  const detail = await DiningSetting.findOne({}, { restaurantCanAddOffers: 1 });
  return detail;
};

module.exports = {
  createDiningSettings,
  getDiningSetting,
  updateDiningSetting,
  getDiningSettingForVendor,
};
