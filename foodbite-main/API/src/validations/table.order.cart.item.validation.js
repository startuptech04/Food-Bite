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

const variationItemSchema = Joi.object({
  variation: Joi.string(),
  selected: Joi.array().items(Joi.string()),
});

const cartItemArraySchema = Joi.object({
  uuid: Joi.string(),
  addons: Joi.string().allow(null, ''),
  food: Joi.string().custom(objectId).required(),
  quantity: Joi.number().required(),
  variations: Joi.array().items(variationItemSchema),
  instruction: Joi.string().allow(null, ''),
});

const addItemToCartValidation = {
  body: Joi.object().keys({
    tableId: Joi.string().custom(objectId).required(),
    tableNumber: Joi.number().required(),
    restaurant: Joi.string().custom(objectId).required(),
    waiter: Joi.string().custom(objectId).required(),
    cartItem: Joi.array().items(cartItemArraySchema).required(),
  }),
};

const ongoingTableItemValidation = {
  params: Joi.object().keys({
    tableId: Joi.string().custom(objectId).required(),
    vendor: Joi.string().custom(objectId).required(),
  }),
};

const ongoingTableOrderValidation = {
  params: Joi.object().keys({
    vendor: Joi.string().custom(objectId).required(),
  }),
};

const vendorOngoingTableOrderValidation = {
  params: Joi.object().keys({
    vendor: Joi.string().custom(objectId).required(),
    tableId: Joi.string().custom(objectId).required(),
  }),
};

const vendorDeleteCartItemValidation = {
  params: Joi.object().keys({
    vendor: Joi.string().custom(objectId).required(),
    id: Joi.string().custom(objectId).required(),
  }),
};

const vendorCompleteTableOrderValidation = {
  body: Joi.object().keys({
    restaurant: Joi.string().custom(objectId).required().allow(null, ''),
    tableId: Joi.string().custom(objectId).required(),
    paymentMode: Joi.string().required().valid('online', 'offline'),
    customerType: Joi.string().required().valid('guest', 'regular'),
    customerName: Joi.string().required().allow(null, 'none'),
    customerCountryCode: Joi.string().required(),
    customerMobileNumber: Joi.string().allow(null, ''),
    discountType: Joi.string().required().valid('per', 'amount'),
    discountAmount: Joi.number().required().allow(0),
    foodServiceCharge: Joi.number().required().allow(0),
    serviceCharge: Joi.number().required().allow(0),
    packageCharge: Joi.number().required().allow(0),
    packageChargeTax: Joi.number().required().allow(0),
    extraCharge: Joi.number().required().allow(0),
  }),
};

const customerAddItemToCartValidation = {
  body: Joi.object().keys({
    tableId: Joi.string().custom(objectId).required(),
    restaurant: Joi.string().custom(objectId).required(),
    cartItem: Joi.array().items(cartItemArraySchema).required(),
    tableNumber: Joi.number().required(),
  }),
};

module.exports = {
  addItemToCartValidation,
  ongoingTableItemValidation,
  ongoingTableOrderValidation,
  vendorOngoingTableOrderValidation,
  vendorDeleteCartItemValidation,
  vendorCompleteTableOrderValidation,
  customerAddItemToCartValidation,
};
