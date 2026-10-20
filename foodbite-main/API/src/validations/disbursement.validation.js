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

const createDisbursement = {
  body: Joi.object().keys({
    type: Joi.string().allow('manual', 'auto'),
    restaurant: Joi.object().allow(),
    driver: Joi.object().allow(),
  }),
};

const idValidation = {
  params: Joi.object().keys({
    disbursementId: Joi.string().custom(objectId),
  }),
};

const disbursementReportValidation = {
  params: Joi.object().keys({
    id: Joi.string().custom(objectId).required(),
  }),
};

const exportValidation = {
  params: Joi.object().keys({
    type: Joi.string().required().valid('excel', 'csv', 'raw'),
    status: Joi.string()
      .required()
      .allow('all', 'pending', 'completed', 'partially_completed', 'cancelled'),
  }),
};

const exportDisbursementReportValidation = {
  params: Joi.object().keys({
    id: Joi.string().custom(objectId).required(),
    type: Joi.string().required().valid('excel', 'csv', 'raw'),
  }),
};

const exportRestaurantReportValidation = {
  query: Joi.object().keys({
    type: Joi.string().required().valid('excel', 'csv', 'raw'),
    filter: Joi.boolean(),
    search: Joi.string().allow(null, ''),
    restaurant: Joi.string().custom(objectId).allow(null, ''),
    payment: Joi.string().allow(null, '', 'all'),
    status: Joi.string().valid('all', 'created', 'accepted', 'rejected'),
    filterDates: Joi.string().allow(null, ''),
  }),
};

const exportDeliverymanReportValidation = {
  query: Joi.object().keys({
    type: Joi.string().required().valid('excel', 'csv', 'raw'),
    filter: Joi.boolean(),
    search: Joi.string().allow(null, ''),
    payment: Joi.string().allow(null, '', 'all'),
    status: Joi.string().valid('all', 'created', 'accepted', 'rejected'),
    filterDates: Joi.string().allow(null, ''),
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
    status: Joi.string().valid('all', 'created', 'accepted', 'rejected'),
    search: Joi.string().allow(null, ''),
  }),
};

module.exports = {
  createDisbursement,
  idValidation,
  disbursementReportValidation,
  exportValidation,
  exportDisbursementReportValidation,
  exportRestaurantReportValidation,
  exportDeliverymanReportValidation,
  cityMasterValidation,
};
