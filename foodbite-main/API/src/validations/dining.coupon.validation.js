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

const createCoupon = {
  body: Joi.object().keys({
    name: Joi.string().required(),
    city: Joi.string().custom(objectId).required(),
    latitude: Joi.number().required(),
    longitude: Joi.number().required(),
    type: Joi.string().required(),
    allRestaurants: Joi.boolean(),
    restaurant: Joi.string().allow(null, ''),
    allUsers: Joi.boolean(),
    user: Joi.string().allow(null, ''),
    code: Joi.string().required(),
    limitSameUser: Joi.number().required(),
    start: Joi.date().required(),
    expires: Joi.date().required(),
    discountType: Joi.string().allow('amount', 'percentage'),
    minDiscount: Joi.number().allow(null, 0, ''),
    maxDiscount: Joi.number().allow(null, 0, ''),
    availability: Joi.string().allow('breakfast', 'lunch', 'dinner'),
    preBookingChargeRequired: Joi.boolean(),
    preBookingChargeAmount: Joi.number().allow(null, 0, ''),
    status: Joi.string().allow('hold', 'live', 'reject', 'hide'),
    translations: Joi.allow(),
    createdById: Joi.string().custom(objectId).required(),
  }),
};

const cityzenCreateCoupon = {
  params: Joi.object().keys({
    master: Joi.string().custom(objectId).required(),
  }),
  body: Joi.object().keys({
    name: Joi.string().required(),
    allRestaurants: Joi.boolean(),
    restaurant: Joi.string().allow(null, ''),
    allUsers: Joi.boolean(),
    user: Joi.string().allow(null, ''),
    code: Joi.string().required(),
    limitSameUser: Joi.number().required(),
    start: Joi.date().required(),
    expires: Joi.date().required(),
    discountType: Joi.string().allow('amount', 'percentage'),
    minDiscount: Joi.number().allow(null, 0, ''),
    maxDiscount: Joi.number().allow(null, 0, ''),
    availability: Joi.string().allow('breakfast', 'lunch', 'dinner'),
    preBookingChargeRequired: Joi.boolean(),
    preBookingChargeAmount: Joi.number().allow(null, 0, ''),
    status: Joi.string().allow('hold', 'live', 'reject', 'hide'),
    translations: Joi.allow(),
    createdById: Joi.string().custom(objectId).required(),
  }),
};

const requestNewCouponValidation = {
  body: Joi.object().keys({
    name: Joi.string().required(),
    code: Joi.string().required(),
    limitSameUser: Joi.number().required(),
    start: Joi.date().required(),
    expires: Joi.date().required(),
    discountType: Joi.string().allow('amount', 'percentage'),
    minDiscount: Joi.number().allow(null, 0, ''),
    maxDiscount: Joi.number().allow(null, 0, ''),
    availability: Joi.string().allow('breakfast', 'lunch', 'dinner'),
    preBookingChargeRequired: Joi.boolean(),
    preBookingChargeAmount: Joi.number().allow(null, 0, ''),
    restaurantId: Joi.string().custom(objectId).required(),
    createdById: Joi.string().custom(objectId).required(),
    translations: Joi.allow(),
  }),
};

const idValidation = {
  params: Joi.object().keys({
    id: Joi.string().custom(objectId),
  }),
};

const deleteVendorCouponValidation = {
  params: Joi.object().keys({
    id: Joi.string().custom(objectId),
    userId: Joi.string().custom(objectId),
  }),
};

const vendorCouponUpdateStatusValidation = {
  params: Joi.object().keys({
    id: Joi.string().custom(objectId),
  }),
  body: Joi.object().keys({
    status: Joi.string().required().allow('live', 'hide'),
  }),
};

const vendorCouponInfoValidation = {
  body: Joi.object().keys({
    id: Joi.string().custom(objectId).required(),
    userId: Joi.string().custom(objectId).required(),
  }),
};

const updateVendorCouponValidation = {
  params: Joi.object().keys({
    id: Joi.string().custom(objectId),
  }),
  body: Joi.object().keys({
    name: Joi.string().required(),
    code: Joi.string().required(),
    limitSameUser: Joi.number().required(),
    start: Joi.date().required(),
    expires: Joi.date().required(),
    discountType: Joi.string().allow('amount', 'percentage'),
    minDiscount: Joi.number().allow(null, 0, ''),
    maxDiscount: Joi.number().allow(null, 0, ''),
    availability: Joi.string().allow('breakfast', 'lunch', 'dinner'),
    preBookingChargeRequired: Joi.boolean(),
    preBookingChargeAmount: Joi.number().allow(null, 0, ''),
    restaurantId: Joi.string().custom(objectId).required(),
    createdById: Joi.string().custom(objectId).required(),
    translations: Joi.allow(),
  }),
};

const redeemValidation = {
  params: Joi.object().keys({
    user: Joi.string().custom(objectId),
    coupon: Joi.string().custom(objectId),
  }),
};

const detailValidation = {
  params: Joi.object().keys({
    id: Joi.string().custom(objectId).required(),
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

const exportValidation = {
  query: Joi.object().keys({
    type: Joi.string().required().valid('excel', 'csv', 'raw'),
    search: Joi.string().allow(null, ''),
    status: Joi.boolean().required(),
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
  createCoupon,
  idValidation,
  requestNewCouponValidation,
  deleteVendorCouponValidation,
  vendorCouponUpdateStatusValidation,
  vendorCouponInfoValidation,
  updateVendorCouponValidation,
  redeemValidation,
  detailValidation,
  cityzenCreateCoupon,
  allValidation,
  exportValidation,
  cityMasterValidation,
};
