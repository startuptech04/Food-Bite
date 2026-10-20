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

const createCategory = {
  body: Joi.object().keys({
    name: Joi.string().required(),
    image: Joi.string().required(),
    restaurant: Joi.string().custom(objectId).required(),
    translations: Joi.allow(),
    status: Joi.boolean().allow(),
  }),
};

const idValidation = {
  params: Joi.object().keys({
    categoryId: Joi.string().custom(objectId),
  }),
};

const myCategoryValidation = {
  params: Joi.object().keys({
    restaurant: Joi.string().custom(objectId),
  }),
};

module.exports = {
  createCategory,
  idValidation,
  myCategoryValidation,
};
