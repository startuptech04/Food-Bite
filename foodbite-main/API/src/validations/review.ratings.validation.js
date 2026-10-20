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

const saveReviewValidation = {
  body: Joi.object().keys({
    user: Joi.string().custom(objectId).required(),
    orders: Joi.string().custom(objectId).required(),
    driver: Joi.string().custom(objectId).allow(null, ''),
    restaurant: Joi.string().custom(objectId).allow(null, ''),
    driverRate: Joi.number().allow(0, '', null).min(1).max(5),
    restaurantRate: Joi.number().allow(0, '', null).min(1).max(5),
    driverMessage: Joi.string().allow(null, ''),
    restaurantMessage: Joi.string().allow(null, ''),
    images: Joi.string().allow(null, ''),
    shortReview: Joi.string().allow(null, ''),
    product: Joi.array().items(
      Joi.object({
        id: Joi.string().custom(objectId),
        rate: Joi.number().min(1).max(5),
        message: Joi.string().allow(null, ''),
      })
    ),
  }),
};

const savePublicRestaurantReviewValidation = {
  body: Joi.object().keys({
    user: Joi.string().custom(objectId).required(),
    restaurant: Joi.string().custom(objectId).allow(null, ''),
    restaurantRate: Joi.number().allow(0, '', null).min(1).max(5),
    restaurantMessage: Joi.string().allow(null, ''),
    images: Joi.string().allow(null, ''),
    shortReview: Joi.string().allow(null, ''),
  }),
};

const getMyReviewListValidation = {
  params: Joi.object().keys({
    uid: Joi.string().custom(objectId).required(),
  }),
};

const getDeliverymanReviewValidation = {
  body: Joi.object().keys({
    limit: Joi.number().required(),
    page: Joi.number().required(),
    id: Joi.string().custom(objectId).required(),
  }),
};

const restaurantReviewValidation = {
  body: Joi.object().keys({
    id: Joi.string().custom(objectId).required(),
    limit: Joi.number().required(),
    page: Joi.number().required(),
  }),
};

module.exports = {
  saveReviewValidation,
  savePublicRestaurantReviewValidation,
  getMyReviewListValidation,
  getDeliverymanReviewValidation,
  restaurantReviewValidation,
};
