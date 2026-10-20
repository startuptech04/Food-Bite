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

const paymentInitiationValidation = {
  body: Joi.object().keys({
    user: Joi.string().custom(objectId).required(),
    payment: Joi.string().custom(objectId).required(),
    orders: Joi.string().custom(objectId).allow(null, ''),
    tiffinSubscription: Joi.string().custom(objectId).allow(null, ''),
    ref: Joi.string().allow(null, ''),
    amount: Joi.number().required(),
    from: Joi.string().required().allow('order', 'wallet'),
  }),
};

const idValidation = {
  params: Joi.object().keys({
    id: Joi.string().custom(objectId).required(),
  }),
};

const getUserOrderTransactionsValidation = {
  body: Joi.object().keys({
    limit: Joi.number().required(),
    page: Joi.number().required(),
    uid: Joi.string().custom(objectId).required(),
  }),
};

const getUserDiningransactionsValidation = {
  body: Joi.object().keys({
    limit: Joi.number().required(),
    page: Joi.number().required(),
    uid: Joi.string().custom(objectId).required(),
  }),
};

const getUserFoodSubscriptionTransactionsValidation = {
  body: Joi.object().keys({
    limit: Joi.number().required(),
    page: Joi.number().required(),
    uid: Joi.string().custom(objectId).required(),
  }),
};

module.exports = {
  paymentInitiationValidation,
  idValidation,
  getUserOrderTransactionsValidation,
  getUserDiningransactionsValidation,
  getUserFoodSubscriptionTransactionsValidation,
};
