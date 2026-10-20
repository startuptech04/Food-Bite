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
const { FavouriteOrder } = require('../models');
const ApiError = require('../utils/ApiError');

const saveFavourite = async (params) => {
  const favourite = await FavouriteOrder.findOne({ user: params.user, order: params.order });
  if (favourite) {
    throw new ApiError(httpStatus.BAD_REQUEST, 'Already saved');
  }
  const saveData = new FavouriteOrder({
    user: params && params.user && params.user !== '' && params.user !== null ? params.user : null,
    order:
      params && params.order && params.order !== '' && params.order !== null ? params.order : null,
  });
  await FavouriteOrder.create(saveData);
  return { success: true };
};

const removeFavourite = async (params) => {
  const favourite = await FavouriteOrder.findOne({ user: params.user, order: params.order });
  if (!favourite) {
    throw new ApiError(httpStatus.BAD_REQUEST, 'Not found');
  }
  await favourite.deleteOne();
  return { success: true };
};

module.exports = {
  saveFavourite,
  removeFavourite,
};
