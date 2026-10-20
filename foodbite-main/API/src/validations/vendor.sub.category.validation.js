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

const createSubCategory = {
  body: Joi.object().keys({
    name: Joi.string().required(),
    category: Joi.string().custom(objectId).required(),
    restaurant: Joi.string().custom(objectId).required(),
    status: Joi.boolean().allow(),
    translations: Joi.allow(),
  }),
};

const idValidation = {
  params: Joi.object().keys({
    subCategoryId: Joi.string().custom(objectId),
  }),
};

const mySubCategoryValidation = {
  params: Joi.object().keys({
    restaurant: Joi.string().custom(objectId),
  }),
};

const mySubCategoryByCateIdValidation = {
  params: Joi.object().keys({
    category: Joi.string().custom(objectId),
    restaurant: Joi.string().custom(objectId),
  }),
};

module.exports = {
  createSubCategory,
  idValidation,
  mySubCategoryValidation,
  mySubCategoryByCateIdValidation,
};
