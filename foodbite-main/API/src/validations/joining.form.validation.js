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

const itemFormElementSchema = Joi.object({
  name: Joi.string().required(),
});

const formElementSchema = Joi.object({
  uuid: Joi.string().required(),
  isRequired: Joi.boolean().required(),
  type: Joi.string().valid('text', 'number', 'file', 'choose', 'date', 'email', 'phone').required(),
  title: Joi.string().required(),
  placeholder: Joi.string().allow('', null),
  items: Joi.array().items(itemFormElementSchema).min(0),
});

const saveRestaurantJoiningFormValidation = {
  body: Joi.object().keys({
    formField: Joi.array().items(formElementSchema),
  }),
};

module.exports = {
  saveRestaurantJoiningFormValidation,
};
