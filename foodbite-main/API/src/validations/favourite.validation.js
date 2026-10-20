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

const Joi = require('joi');
const { objectId } = require('./custom.validation');

const saveFavourite = {
  body: Joi.object().keys({
    user: Joi.string().custom(objectId).required(),
    type: Joi.string().required().allow('restaurant', 'food'),
    restaurant: Joi.string().custom(objectId).allow(null, ''),
    food: Joi.string().custom(objectId).allow(null, ''),
  }),
};

const getFavouriteRestaurants = {
  body: Joi.object().keys({
    latitude: Joi.number().required(),
    longitude: Joi.number().required(),
    uid: Joi.string().custom(objectId).required(),
    limit: Joi.number().required(),
    page: Joi.number().required(),
  }),
};

const getFavouriteFoods = {
  body: Joi.object().keys({
    latitude: Joi.number().required(),
    longitude: Joi.number().required(),
    uid: Joi.string().custom(objectId).required(),
    limit: Joi.number().required(),
    page: Joi.number().required(),
  }),
};

const deleteFavouriteFoodValidation = {
  params: Joi.object().keys({
    foodId: Joi.string().custom(objectId).required(),
    userId: Joi.string().custom(objectId).required(),
  }),
};

const deleteFavouriteRestaurantValidation = {
  params: Joi.object().keys({
    restaurantId: Joi.string().custom(objectId).required(),
    userId: Joi.string().custom(objectId).required(),
  }),
};

module.exports = {
  saveFavourite,
  getFavouriteRestaurants,
  getFavouriteFoods,
  deleteFavouriteFoodValidation,
  deleteFavouriteRestaurantValidation,
};
