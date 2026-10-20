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

const getNotificationValidation = {
  params: Joi.object().keys({
    slug: Joi.string().required(),
  }),
};

const saveOrderNotificationTranslationValidation = {
  body: Joi.object().keys({
    title: Joi.string().required(),
    description: Joi.string().required(),
    slug: Joi.string().required(),
    translations: Joi.allow(),
  }),
};

module.exports = { getNotificationValidation, saveOrderNotificationTranslationValidation };
