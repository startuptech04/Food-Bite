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

const saveExpenseValidation = {
  body: Joi.object().keys({
    expenseType: Joi.string().required().valid('other'),
    restaurant: Joi.string().custom(objectId).allow(null, ''),
    amount: Joi.number().required(),
  }),
};

const exportValidation = {
  query: Joi.object().keys({
    exportType: Joi.string().required().valid('excel', 'csv', 'raw'),
    type: Joi.string().valid(
      'all',
      'order_product_discout',
      'pos_order_product_discount',
      'table_order_product_discount',
      'pos_order_extra_discount',
      'table_order_extra_discount',
      'coupon',
      'dining_coupon',
      'dining_booking_discount',
      'refund_order',
      'other'
    ),
    restaurant: Joi.string().custom(objectId).required(),
  }),
};

module.exports = {
  saveExpenseValidation,
  exportValidation,
};
