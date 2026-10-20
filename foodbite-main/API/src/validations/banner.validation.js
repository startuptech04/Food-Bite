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

const createBanner = {
  body: Joi.object().keys({
    title: Joi.string().required(),
    type: Joi.string().required().allow('restaurant', 'food', 'external'),
    city: Joi.string().custom(objectId).required(),
    restaurant: Joi.string().custom(objectId).allow(null, ''),
    food: Joi.string().custom(objectId).allow(null, ''),
    image: Joi.string().required(),
    external: Joi.string().allow(null, ''),
    translations: Joi.allow(),
  }),
};

const cityzenCreateBanner = {
  params: Joi.object().keys({
    master: Joi.string().custom(objectId).required(),
  }),
  body: Joi.object().keys({
    title: Joi.string().required(),
    type: Joi.string().required().allow('restaurant', 'food', 'external'),
    restaurant: Joi.string().custom(objectId).allow(null, ''),
    food: Joi.string().custom(objectId).allow(null, ''),
    image: Joi.string().required(),
    external: Joi.string().allow(null, ''),
    translations: Joi.allow(),
  }),
};

const idValidation = {
  params: Joi.object().keys({
    bannerId: Joi.string().custom(objectId),
  }),
};

const cityzenUpdateValidation = {
  params: Joi.object().keys({
    master: Joi.string().custom(objectId).required(),
    bannerId: Joi.string().custom(objectId),
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
  createBanner,
  idValidation,
  cityzenCreateBanner,
  cityzenUpdateValidation,
  allValidation,
  exportValidation,
  cityMasterValidation,
};
