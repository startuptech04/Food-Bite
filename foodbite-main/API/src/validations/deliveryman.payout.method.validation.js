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

const formElementSchema = Joi.object({
  fieldName: Joi.string().required(),
  fieldType: Joi.string().required(),
  fieldValue: Joi.string().required(),
});

const createPayoutMethodValidation = {
  body: Joi.object().keys({
    method: Joi.string().custom(objectId).required(),
    deliveryman: Joi.string().custom(objectId).required(),
    formElement: Joi.array().items(formElementSchema),
  }),
};

const deliverymanValidation = {
  params: Joi.object().keys({
    deliveryman: Joi.string().custom(objectId).required(),
  }),
};

const deletePayoutMethodValidation = {
  params: Joi.object().keys({
    id: Joi.string().custom(objectId).required(),
    deliveryman: Joi.string().custom(objectId).required(),
  }),
};

const payoutMethodDetailValidation = {
  params: Joi.object().keys({
    id: Joi.string().custom(objectId).required(),
    deliveryman: Joi.string().custom(objectId).required(),
  }),
};

const updatePayoutMethodValidation = {
  body: Joi.object().keys({
    id: Joi.string().custom(objectId).required(),
    deliveryman: Joi.string().custom(objectId).required(),
    formElement: Joi.array().items(formElementSchema),
  }),
};

const changeDefaultPayoutMethodValidation = {
  body: Joi.object().keys({
    id: Joi.string().custom(objectId).required(),
    deliveryman: Joi.string().custom(objectId).required(),
    isDefault: Joi.boolean().required(),
  }),
};

module.exports = {
  createPayoutMethodValidation,
  deliverymanValidation,
  deletePayoutMethodValidation,
  payoutMethodDetailValidation,
  updatePayoutMethodValidation,
  changeDefaultPayoutMethodValidation,
};
