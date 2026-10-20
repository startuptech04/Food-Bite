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
const { password, objectId } = require('./custom.validation');

const createKitchenOwner = {
  body: Joi.object().keys({
    email: Joi.string().required().email(),
    password: Joi.string().required().custom(password),
    firstName: Joi.string().required(),
    lastName: Joi.string().required(),
    countryCode: Joi.string().required(),
    mobile: Joi.number().required(),
    image: Joi.string().required(),
    restaurant: Joi.string().custom(objectId).required(),
    gender: Joi.string().required(),
  }),
};

const allValidation = {
  query: Joi.object().keys({
    sortBy: Joi.string(),
    limit: Joi.number().integer(),
    page: Joi.number().integer(),
    search: Joi.string().allow(null, ''),
  }),
};

const restaurantValidation = {
  params: Joi.object().keys({
    restaurant: Joi.string().custom(objectId),
  }),
};

const idValidation = {
  params: Joi.object().keys({
    kitchenId: Joi.string().custom(objectId).required(),
  }),
};

const updateKitchenOwnerInfoValidation = {
  params: Joi.object().keys({
    userId: Joi.string().custom(objectId).required(),
  }),
  body: Joi.object().keys({
    firstName: Joi.string().required(),
    lastName: Joi.string().required(),
    image: Joi.string().required(),
    gender: Joi.string().required(),
  }),
};

const updateKitchenOwnerStatusValidation = {
  params: Joi.object().keys({
    kitchenId: Joi.string().custom(objectId).required(),
  }),
  body: Joi.object().keys({
    status: Joi.boolean().required(),
  }),
};

const kitchenOrderValidation = {
  body: Joi.object().keys({
    limit: Joi.number().required(),
    page: Joi.number().required(),
    owner: Joi.string().custom(objectId).required(),
    status: Joi.string().required().allow('new', 'preparing', 'completed'),
  }),
};

const prepareKitchenOrderValidation = {
  params: Joi.object().keys({
    order: Joi.string().custom(objectId).required(),
    owner: Joi.string().custom(objectId).required(),
  }),
};

const completeKitchenOrderValidation = {
  params: Joi.object().keys({
    order: Joi.string().custom(objectId).required(),
    owner: Joi.string().custom(objectId).required(),
  }),
};

const kitchenOrderDetailValidation = {
  params: Joi.object().keys({
    order: Joi.string().custom(objectId).required(),
    owner: Joi.string().custom(objectId).required(),
  }),
};

const exportValidation = {
  query: Joi.object().keys({
    type: Joi.string().required().valid('excel', 'csv', 'raw'),
    search: Joi.string().allow(null, ''),
  }),
};

const cityMasterValidation = {
  params: Joi.object().keys({
    master: Joi.string().custom(objectId).required(),
  }),
  query: Joi.object().keys({
    sortBy: Joi.string(),
    limit: Joi.number().integer(),
    page: Joi.number().integer(),
    search: Joi.string().allow(null, ''),
  }),
};

module.exports = {
  createKitchenOwner,
  restaurantValidation,
  idValidation,
  allValidation,
  updateKitchenOwnerInfoValidation,
  updateKitchenOwnerStatusValidation,
  kitchenOrderValidation,
  prepareKitchenOrderValidation,
  completeKitchenOrderValidation,
  kitchenOrderDetailValidation,
  exportValidation,
  cityMasterValidation,
};
