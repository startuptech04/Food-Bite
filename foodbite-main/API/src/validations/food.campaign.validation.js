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

const createFoodCampaign = {
  body: Joi.object().keys({
    title: Joi.string().required(),
    shortDescription: Joi.string().required(),
    city: Joi.string().custom(objectId).required(),
    foods: Joi.string().allow(null, ''),
    image: Joi.string().required(),
    startDate: Joi.date().required(),
    endDate: Joi.date().required(),
    startTime: Joi.string().required(),
    endTime: Joi.string().required(),
    translations: Joi.allow(),
  }),
};

const cityzenCreateFoodCampaign = {
  params: Joi.object().keys({
    master: Joi.string().custom(objectId).required(),
  }),
  body: Joi.object().keys({
    title: Joi.string().required(),
    shortDescription: Joi.string().required(),
    foods: Joi.string().allow(null, ''),
    image: Joi.string().required(),
    startDate: Joi.date().required(),
    endDate: Joi.date().required(),
    startTime: Joi.string().required(),
    endTime: Joi.string().required(),
    translations: Joi.allow(),
  }),
};

const idValidation = {
  params: Joi.object().keys({
    campaignId: Joi.string().custom(objectId),
  }),
};

const contentValidation = {
  params: Joi.object().keys({
    campaignId: Joi.string().custom(objectId),
  }),
  body: Joi.object().keys({
    campaignId: Joi.string().custom(objectId),
    uid: Joi.string().custom(objectId).allow('', null),
  }),
};

const cityIdValidation = {
  params: Joi.object().keys({
    cityId: Joi.string().custom(objectId),
  }),
};

const restaurantIdValidation = {
  params: Joi.object().keys({
    restaurantId: Joi.string().custom(objectId),
  }),
};

const restaurantAndCampaignIdValidation = {
  params: Joi.object().keys({
    campaignId: Joi.string().custom(objectId),
    restaurantId: Joi.string().custom(objectId),
  }),
};

const leaveAndJoinCampaignIdValidation = {
  params: Joi.object().keys({
    campaignId: Joi.string().custom(objectId),
    foodId: Joi.string().custom(objectId),
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
  createFoodCampaign,
  idValidation,
  cityIdValidation,
  restaurantIdValidation,
  restaurantAndCampaignIdValidation,
  leaveAndJoinCampaignIdValidation,
  contentValidation,
  detailValidation,
  cityzenCreateFoodCampaign,
  allValidation,
  exportValidation,
  cityMasterValidation,
};
