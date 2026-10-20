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

const saveFavouriteOrderValidation = {
  body: Joi.object().keys({
    user: Joi.string().custom(objectId).required(),
    order: Joi.string().custom(objectId).required(),
  }),
};

const removeFavouriteOrderValidation = {
  body: Joi.object().keys({
    user: Joi.string().custom(objectId).required(),
    order: Joi.string().custom(objectId).required(),
  }),
};

module.exports = { saveFavouriteOrderValidation, removeFavouriteOrderValidation };
