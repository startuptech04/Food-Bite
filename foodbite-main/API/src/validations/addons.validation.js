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

const createAddons = {
  body: Joi.object().keys({
    name: Joi.string().required(),
    price: Joi.number().required(),
    stockType: Joi.string().valid('unlimited', 'limited', 'daily').required(),
    stockNumber: Joi.number().allow(-1, 0).required(),
    restaurant: Joi.string().custom(objectId),
    translations: Joi.allow(),
    status: Joi.boolean().allow(),
    inStock: Joi.boolean().allow(),
  }),
};

const idValidation = {
  params: Joi.object().keys({
    addonId: Joi.string().custom(objectId),
  }),
};

const myAddonsValidation = {
  params: Joi.object().keys({
    restaurant: Joi.string().custom(objectId),
  }),
};

const allValidation = {
  query: Joi.object().keys({
    sortBy: Joi.string(),
    limit: Joi.number().integer(),
    page: Joi.number().integer(),
    search: Joi.string().allow(null, ''),
  }),
};

const exportValidation = {
  query: Joi.object().keys({
    type: Joi.string().required().valid('excel', 'csv', 'raw'),
    search: Joi.string().allow(null, ''),
  }),
};

const cityMasterValidation = {
  params: Joi.object().keys({
    master: Joi.string().custom(objectId).required(),
  }),
  query: Joi.object().keys({
    sortBy: Joi.string(),
    limit: Joi.number().integer(),
    page: Joi.number().integer(),
    search: Joi.string().allow(null, ''),
  }),
};

module.exports = {
  createAddons,
  idValidation,
  myAddonsValidation,
  allValidation,
  exportValidation,
  cityMasterValidation,
};
