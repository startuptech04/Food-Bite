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

const createSettings = {
  body: Joi.object().keys({
    driverLoginWith: Joi.string()
      .valid('email_password', 'phone_password', 'phone_otp', 'email_otp')
      .allow(),
    driverResetPasswordWith: Joi.string().valid('phone_otp', 'email_otp').allow(),
    selfRegistration: Joi.boolean().allow(),
    cashInHand: Joi.boolean().allow(),
    minCashInHand: Joi.number().allow(),
    maxCashInHand: Joi.number().allow(),
    getTip: Joi.boolean().allow(),
    showEarning: Joi.boolean().allow(),
    maxOrderLimit: Joi.number().allow(),
    pickupProof: Joi.boolean().allow(),
    deliveryProof: Joi.boolean().allow(),
    canInitiateChat: Joi.boolean().allow(),
    canInitiateCall: Joi.boolean().allow(),
    earningModel: Joi.string().required().allow('salaried', 'order'),
    salaryAmount: Joi.number().allow(),
    earningOnOrder: Joi.string().allow('fixed', 'distance'),
    distanceRadiusForFixed: Joi.number().allow(),
    earningFixedDistanceAmount: Joi.number().allow(),
    earningAmount: Joi.number().allow(),
    earningSurplusDistanceAmount: Joi.number().allow(),
    haveIncentive: Joi.boolean().allow(),
  }),
};

const idValidation = {
  params: Joi.object().keys({
    settingId: Joi.string().custom(objectId),
  }),
};

module.exports = {
  createSettings,
  idValidation,
};
