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

const saveRefundRequestValidation = {
  body: Joi.object().keys({
    user: Joi.string().custom(objectId).required(),
    orders: Joi.string().custom(objectId).required(),
    reason: Joi.string().custom(objectId).required(),
    restaurant: Joi.string().custom(objectId).required(),
    payment: Joi.string().custom(objectId).required(),
  }),
};

const adminListValidation = {
  query: Joi.object().keys({
    limit: Joi.number().required(),
    page: Joi.number().required(),
    search: Joi.string().allow(null, ''),
    status: Joi.string().valid('all', 'initiated', 'refunded', 'partially_refunded', 'cancelled'),
  }),
};

const getRefundRequestInfoValidation = {
  params: Joi.object().keys({
    requestId: Joi.string().custom(objectId).required(),
  }),
};

const cancelRefundRequestValidation = {
  body: Joi.object().keys({
    requestId: Joi.string().custom(objectId).required(),
    cancelReason: Joi.string().required(),
  }),
};

const refundFromMerchantValidation = {
  body: Joi.object().keys({
    requestId: Joi.string().custom(objectId).required(),
  }),
};

const approveRefundRequestValidation = {
  body: Joi.object().keys({
    requestId: Joi.string().custom(objectId).required(),
    orderId: Joi.string().custom(objectId).required(),
    refundTo: Joi.string().required().allow('wallet', 'payment'),
    refundType: Joi.string().required().allow('full', 'partial'),
    refundAmount: Joi.number().allow(null, '', 0),
  }),
};

const exportValidation = {
  query: Joi.object().keys({
    type: Joi.string().required().valid('excel', 'csv', 'raw'),
    status: Joi.string()
      .required()
      .allow('all', 'initiated', 'refunded', 'partially_refunded', 'cancelled'),
    search: Joi.string().allow(null, ''),
  }),
};

const cityMasterValidation = {
  params: Joi.object().keys({
    master: Joi.string().custom(objectId).required(),
  }),
  query: Joi.object().keys({
    limit: Joi.number().required(),
    page: Joi.number().required(),
    status: Joi.string()
      .required()
      .allow('all', 'initiated', 'refunded', 'partially_refunded', 'cancelled'),
    search: Joi.string().allow(null, ''),
  }),
};

module.exports = {
  saveRefundRequestValidation,
  adminListValidation,
  getRefundRequestInfoValidation,
  cancelRefundRequestValidation,
  approveRefundRequestValidation,
  refundFromMerchantValidation,
  exportValidation,
  cityMasterValidation,
};
