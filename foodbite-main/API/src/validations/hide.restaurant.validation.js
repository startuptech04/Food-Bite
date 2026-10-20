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

const hideRestaurantValidation = {
  body: Joi.object().keys({
    user: Joi.string().custom(objectId).required(),
    restaurant: Joi.string().custom(objectId).required(),
    reason: Joi.string().custom(objectId).allow(null, ''),
  }),
};

const showRestaurantValidation = {
  body: Joi.object().keys({
    user: Joi.string().custom(objectId).required(),
    restaurant: Joi.string().custom(objectId).required(),
  }),
};

const updateHideReasonValidation = {
  body: Joi.object().keys({
    user: Joi.string().custom(objectId).required(),
    restaurant: Joi.string().custom(objectId).required(),
    reason: Joi.string().custom(objectId).required(),
  }),
};

const getMyHiddenRestaurantsValidation = {
  body: Joi.object().keys({
    uid: Joi.string().custom(objectId).required(),
    latitude: Joi.number().required(),
    longitude: Joi.number().required(),
  }),
};

module.exports = {
  hideRestaurantValidation,
  showRestaurantValidation,
  updateHideReasonValidation,
  getMyHiddenRestaurantsValidation,
};
