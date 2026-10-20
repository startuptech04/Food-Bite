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

const createBonusValidation = {
  body: Joi.object().keys({
    name: Joi.string().required(),
    shortDescription: Joi.string().required(),
    image: Joi.string().required(),
    start: Joi.date().required(),
    expires: Joi.date().required(),
    bonusType: Joi.string().allow('amount', 'percentage'),
    bonusAmount: Joi.number().allow(null, 0, ''),
    minWalletAmount: Joi.number().allow(null, 0, ''),
    maxBonusAmount: Joi.number().allow(null, 0, ''),
    translations: Joi.allow(),
  }),
};

const updateStatusValidation = {
  params: Joi.object().keys({
    id: Joi.string().custom(objectId),
  }),
  body: Joi.object().keys({
    status: Joi.boolean().required(),
  }),
};

const idValidation = {
  params: Joi.object().keys({
    id: Joi.string().custom(objectId),
  }),
};

const updateValidation = {
  params: Joi.object().keys({
    id: Joi.string().custom(objectId),
  }),
  body: Joi.object().keys({
    name: Joi.string().required(),
    shortDescription: Joi.string().required(),
    image: Joi.string().required(),
    start: Joi.date().required(),
    expires: Joi.date().required(),
    bonusType: Joi.string().allow('amount', 'percentage'),
    bonusAmount: Joi.number().allow(null, 0, ''),
    minWalletAmount: Joi.number().allow(null, 0, ''),
    maxBonusAmount: Joi.number().allow(null, 0, ''),
    translations: Joi.allow(),
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
  createBonusValidation,
  updateStatusValidation,
  idValidation,
  updateValidation,
  allValidation,
  exportValidation,
};
