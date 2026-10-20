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

const createOrderSettings = {
  body: Joi.object().keys({
    deliveryVerification: Joi.boolean().allow(),
    homeDelivery: Joi.boolean().allow(),
    takeaway: Joi.boolean().allow(),
    repeatOrderOption: Joi.boolean().allow(),
    subscriptionOrder: Joi.boolean().allow(),
    includeChargesForSubscription: Joi.boolean().allow(),
    restaurantCanCancelTiffinSubscriptionPackage: Joi.boolean().allow(),
    userCanCancelTiffinSubscriptionPackage: Joi.boolean().allow(),
    scheduleDelivery: Joi.boolean().allow(),
    restaurantCanCancelOrder: Joi.boolean().allow(),
    driverCanCancelOrder: Joi.boolean().allow(),
    orderConfirmationModel: Joi.string().allow(),
    ratingStyle: Joi.string().allow('emoji', 'star'),
    timeIntervalForScheduleDelivery: Joi.object().allow(),
    instantOrder: Joi.boolean().allow(),
    customerOrderDate: Joi.boolean().allow(),
    customerCanOrderWithinDays: Joi.number().allow(),
  }),
};

const idValidation = {
  params: Joi.object().keys({
    settingId: Joi.string().custom(objectId),
  }),
};

const settingValidation = {
  body: Joi.object().keys({
    userId: Joi.string().custom(objectId).required(),
    restaurant: Joi.string().custom(objectId).required(),
    deliveryAddressId: Joi.string().custom(objectId).allow('', null),
    userLatitude: Joi.number().required(),
    userLongitude: Joi.number().required(),
    trackingId: Joi.string().custom(objectId).required(),
  }),
};

module.exports = {
  createOrderSettings,
  idValidation,
  settingValidation,
};
