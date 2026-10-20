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

const createSMSProviderConfig = {
  body: Joi.object().keys({
    slug: Joi.string().required(),
    credentials: Joi.object().required(),
    isDefault: Joi.boolean().required(),
    template: Joi.allow(),
  }),
};

const idValidation = {
  params: Joi.object().keys({
    slug: Joi.string(),
  }),
};

const demoValidation = {
  body: Joi.object().keys({
    mobile: Joi.string().required(),
    locale: Joi.string().required(),
  }),
};

const firebaseWebDemoValidation = {
  query: Joi.object().keys({
    mobile: Joi.string().required(),
    locale: Joi.string().required(),
    redirect: Joi.string().required(),
  }),
};

module.exports = {
  createSMSProviderConfig,
  idValidation,
  demoValidation,
  firebaseWebDemoValidation,
};
