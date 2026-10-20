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

const createSubscriptionTiffinValidation = {
  body: Joi.object().keys({
    name: Joi.string().required(),
    shortDescription: Joi.string().required(),
    image: Joi.string().required(),
    restaurant: Joi.string().custom(objectId).required(),
    foods: Joi.string().required(),
    interval: Joi.string().required().allow('week', 'fortnight', 'month'),
    offDays: Joi.string().allow('', null),
    totalOrder: Joi.number().required(),
    available: Joi.string().required().allow('breakfast', 'lunch', 'dinner'),
    timeSlots: Joi.array()
      .allow(
        Joi.object({
          startTime: Joi.string().allow('', null),
          endTime: Joi.string().allow('', null),
        })
      )
      .allow(),
    orderTo: Joi.string().required().allow('homedelivery', 'selfpickup'),
    deliveryArea: Joi.number().allow(0, '', null),
    canSelectAddon: Joi.boolean().required(),
    canSelectVariation: Joi.boolean().required(),
    price: Joi.number().required(),
    discountType: Joi.string().allow(null, ''),
    discount: Joi.number().allow(null, ''),
    notice: Joi.array().allow(),
    translations: Joi.array().allow(),
    status: Joi.string().allow('', null),
  }),
};

const getBasicValidation = {
  params: Joi.object().keys({
    restaurant: Joi.string().custom(objectId).required(),
  }),
};

const getPackageListVendorValidation = {
  params: Joi.object().keys({
    restaurant: Joi.string().custom(objectId).required(),
  }),
};

const idValidation = {
  params: Joi.object().keys({
    id: Joi.string().custom(objectId).required(),
    restaurant: Joi.string().custom(objectId).required(),
  }),
};

const updateValidation = {
  params: Joi.object().keys({
    id: Joi.string().custom(objectId).required(),
  }),
};

const deleteValidation = {
  params: Joi.object().keys({
    id: Joi.string().custom(objectId).required(),
  }),
};

const updateAdminStatusValidation = {
  params: Joi.object().keys({
    id: Joi.string().custom(objectId).required(),
  }),
  body: Joi.object().keys({
    status: Joi.string().required().allow('live', 'hold', 'hide'),
  }),
};

const updateVendorStatusValidation = {
  params: Joi.object().keys({
    id: Joi.string().custom(objectId).required(),
  }),
  body: Joi.object().keys({
    status: Joi.string().required().allow('hide', 'live'),
  }),
};

const getDetailValidation = {
  params: Joi.object().keys({
    id: Joi.string().custom(objectId).required(),
  }),
};

const getSubscriptionPackageFromVendorValidation = {
  body: Joi.object().keys({
    restaurant: Joi.string().custom(objectId).required(),
    limit: Joi.number().required(),
    page: Joi.number().required(),
  }),
};

const allValidation = {
  query: Joi.object().keys({
    limit: Joi.number().required(),
    page: Joi.number().required(),
    search: Joi.string().allow(null, ''),
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
    limit: Joi.number().required(),
    page: Joi.number().required(),
    search: Joi.string().allow(null, ''),
  }),
};

module.exports = {
  createSubscriptionTiffinValidation,
  getBasicValidation,
  getPackageListVendorValidation,
  idValidation,
  updateValidation,
  deleteValidation,
  updateAdminStatusValidation,
  updateVendorStatusValidation,
  getDetailValidation,
  getSubscriptionPackageFromVendorValidation,
  allValidation,
  exportValidation,
  cityMasterValidation,
};
