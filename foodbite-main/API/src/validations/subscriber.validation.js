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

const createSubscriber = {
  body: Joi.object().keys({
    subscription: Joi.string().custom(objectId).allow(null, ''),
    restaurant: Joi.string().custom(objectId).required(),
  }),
};

const idValidation = {
  params: Joi.object().keys({
    subscriberId: Joi.string().custom(objectId),
  }),
};

const extendValidation = {
  body: Joi.object().keys({
    id: Joi.string().custom(objectId).required(),
    startDate: Joi.string().required(),
    endDate: Joi.string().required(),
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

module.exports = {
  createSubscriber,
  idValidation,
  extendValidation,
  allValidation,
  exportValidation,
};
