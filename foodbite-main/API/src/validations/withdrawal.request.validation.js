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

const createRestaurantWithdrawalRequestValidation = {
  body: Joi.object().keys({
    restaurant: Joi.string().custom(objectId).required(),
    restaurantPayoutMethod: Joi.string().custom(objectId).required(),
    withdrawalMethod: Joi.string().custom(objectId).required(),
    amount: Joi.number().required(),
  }),
};

const createDeliverymanWithdrawalRequestValidation = {
  body: Joi.object().keys({
    deliveryman: Joi.string().custom(objectId).required(),
    deliverymanPayoutMethod: Joi.string().custom(objectId).required(),
    withdrawalMethod: Joi.string().custom(objectId).required(),
    amount: Joi.number().required(),
  }),
};

const idValidation = {
  params: Joi.object().keys({
    id: Joi.string().custom(objectId).required(),
  }),
};

const declineWithdrawalRequestValidation = {
  body: Joi.object().keys({
    id: Joi.string().custom(objectId).required(),
    reason: Joi.string().required(),
  }),
};

const approveWithdrawalRequestValidation = {
  body: Joi.object().keys({
    id: Joi.string().custom(objectId).required(),
    approvedNotes: Joi.string().required(),
    proof: Joi.string().allow(null, ''),
  }),
};

const vendorHistoryValidation = {
  params: Joi.object().keys({
    vendor: Joi.string().custom(objectId).required(),
  }),
};

const deliverymanHistoryValidation = {
  params: Joi.object().keys({
    deliveryman: Joi.string().custom(objectId).required(),
  }),
};

const allValidation = {
  query: Joi.object().keys({
    sortBy: Joi.string(),
    limit: Joi.number().integer(),
    page: Joi.number().integer(),
    search: Joi.string().allow(null, ''),
    status: Joi.string().required().allow('all', 'approved', 'rejected', 'pending'),
  }),
};

const exportValidation = {
  query: Joi.object().keys({
    type: Joi.string().required().valid('excel', 'csv', 'raw'),
    search: Joi.string().allow(null, ''),
    status: Joi.string().required().allow('all', 'approved', 'rejected', 'pending'),
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
    status: Joi.string().required().allow('all', 'approved', 'rejected', 'pending'),
  }),
};

module.exports = {
  createRestaurantWithdrawalRequestValidation,
  createDeliverymanWithdrawalRequestValidation,
  idValidation,
  declineWithdrawalRequestValidation,
  approveWithdrawalRequestValidation,
  vendorHistoryValidation,
  deliverymanHistoryValidation,
  allValidation,
  exportValidation,
  cityMasterValidation,
};
