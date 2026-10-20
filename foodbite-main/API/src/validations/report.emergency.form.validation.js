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

const saveReportEmergencyValidation = {
  body: Joi.object().keys({
    type: Joi.string().required(),
    userName: Joi.string().required(),
    userCountryCode: Joi.string().required().required(),
    userContact: Joi.string().required(),
    userEmail: Joi.string().required().email().required(),
    shortDescription: Joi.string().required(),
  }),
};

const deleteReportEmergencyValidation = {
  params: Joi.object().keys({
    id: Joi.string().custom(objectId).required(),
  }),
};

const updateReportEmergencyValidation = {
  body: Joi.object().keys({
    id: Joi.string().custom(objectId).required(),
    email: Joi.string().required().email().required(),
    text: Joi.string().required(),
  }),
};

const allValidation = {
  query: Joi.object().keys({
    sortBy: Joi.string(),
    limit: Joi.number().integer(),
    page: Joi.number().integer(),
    status: Joi.boolean().required(),
    search: Joi.string().allow(null, ''),
  }),
};

const exportValidation = {
  query: Joi.object().keys({
    type: Joi.string().required().valid('excel', 'csv', 'raw'),
    status: Joi.boolean().required(),
    search: Joi.string().allow(null, ''),
  }),
};

module.exports = {
  saveReportEmergencyValidation,
  deleteReportEmergencyValidation,
  updateReportEmergencyValidation,
  allValidation,
  exportValidation,
};
