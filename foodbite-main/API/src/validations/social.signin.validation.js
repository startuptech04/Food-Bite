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

const createOrUpdateSocialSignin = {
  body: Joi.object().keys({
    appleSignin: Joi.boolean().required(),
    googleSignin: Joi.boolean().required(),
    facebookSignin: Joi.boolean().required(),
    configCredsRaw: Joi.object({
      google_client_id: Joi.string().allow('', null),
      google_server_id: Joi.string().allow('', null),
    }).required(),
  }),
};

const idValidation = {
  params: Joi.object().keys({
    id: Joi.string().custom(objectId).required(),
  }),
};

module.exports = {
  createOrUpdateSocialSignin,
  idValidation,
};
