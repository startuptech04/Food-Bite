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

const idValidation = {
  params: Joi.object().keys({
    id: Joi.string().custom(objectId).required(),
  }),
};

const updateSettingValidation = {
  params: Joi.object().keys({
    id: Joi.string().custom(objectId).required(),
  }),
  body: Joi.object().keys({
    newsletters: Joi.boolean().required(),
    promoEmail: Joi.boolean().required(),
    promoNotification: Joi.boolean().required(),
    promoWhatsApp: Joi.boolean().required(),
    socialEmail: Joi.boolean().required(),
    socialNotification: Joi.boolean().required(),
    orderEmail: Joi.boolean().required(),
    orderNotification: Joi.boolean().required(),
    orderWhatsApp: Joi.boolean().required(),
    importantUpdate: Joi.boolean().required(),
  }),
};

module.exports = {
  idValidation,
  updateSettingValidation,
};
