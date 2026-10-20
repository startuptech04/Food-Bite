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

const saveComplaintValidation = {
  body: Joi.object().keys({
    orders: Joi.string().custom(objectId).required(),
    reason: Joi.string().custom(objectId).allow(null, ''),
    title: Joi.string().required(),
    brief: Joi.string().required(),
    proof: Joi.string().allow(null, ''),
    issueWith: Joi.string().required().allow('customer', 'deliveryman'),
    restaurant: Joi.string().custom(objectId).allow(null, ''),
    driver: Joi.string().custom(objectId).allow(null, ''),
    customer: Joi.string().custom(objectId).allow(null, ''),
    user: Joi.string().custom(objectId).required(),
  }),
};

module.exports = {
  saveComplaintValidation,
};
