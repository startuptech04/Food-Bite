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

const saveProof = {
  body: Joi.object().keys({
    orderId: Joi.string().custom(objectId),
    pickup: Joi.string().allow('', null),
    dropup: Joi.string().allow('', null),
    type: Joi.string().required().allow('pick', 'drop'),
  }),
};

module.exports = {
  saveProof,
};
