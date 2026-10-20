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

const saveExpenseValidation = {
  body: Joi.object().keys({
    expenseType: Joi.string()
      .required()
      .valid(
        'it_support_service',
        'ads',
        'employee_expenses',
        'outsource',
        'payment_gateway_charge',
        'other'
      ),
    amount: Joi.number().required(),
  }),
};

const exportValidation = {
  params: Joi.object().keys({
    type: Joi.string().required().valid('excel', 'csv', 'raw'),
    status: Joi.string()
      .required()
      .allow(
        'all',
        'coupon',
        'delivery_charge',
        'referral',
        'wallet_bonus',
        'loyalty_points',
        'dining_booking_coupon',
        'customer_wallet_credit',
        'it_support_service',
        'ads',
        'employee_expenses',
        'outsource',
        'payment_gateway_charge',
        'other'
      ),
  }),
};

module.exports = {
  saveExpenseValidation,
  exportValidation,
};
