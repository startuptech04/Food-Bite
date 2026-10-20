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

const createPaymentConfig = {
  body: Joi.object().keys({
    name: Joi.string().required(),
    slug: Joi.string().required(),
    image: Joi.string().required(),
    environment: Joi.boolean().required(),
    credentials: Joi.object().required(),
    translations: Joi.allow(),
    paymentWay: Joi.string().allow('online', 'offline'),
    isDefault: Joi.boolean().required(),
    status: Joi.boolean().required(),
  }),
};

const idValidation = {
  params: Joi.object().keys({
    slug: Joi.string(),
  }),
};

const allPaymentValidation = {
  query: Joi.object().keys({
    limit: Joi.number().required(),
    page: Joi.number().required(),
    filter: Joi.boolean(),
    status: Joi.string().allow(null, '').valid('initiated', 'paid', 'cancelled'),
    kind: Joi.string()
      .allow(null, '')
      .valid(
        'order',
        'wallet',
        'tiffinsubscription',
        'booking',
        'restaurant_register',
        'renew_subscription'
      ),
    filterDates: Joi.string().allow(null, ''),
    search: Joi.string().allow(null, ''),
  }),
};

const exportPaymentValidation = {
  query: Joi.object().keys({
    type: Joi.string().required().valid('excel', 'csv', 'raw'),
    filter: Joi.boolean(),
    status: Joi.string().allow(null, '').valid('initiated', 'paid', 'cancelled'),
    kind: Joi.string()
      .allow(null, '')
      .valid(
        'order',
        'wallet',
        'tiffinsubscription',
        'booking',
        'restaurant_register',
        'renew_subscription'
      ),
    filterDates: Joi.string().allow(null, ''),
    search: Joi.string().allow(null, ''),
  }),
};

module.exports = {
  createPaymentConfig,
  idValidation,
  allPaymentValidation,
  exportPaymentValidation,
};
