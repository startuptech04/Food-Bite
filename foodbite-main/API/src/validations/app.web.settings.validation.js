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

const createOrUpdateAppWebSettings = {
  body: Joi.object().keys({
    showPopularFood: Joi.boolean().allow(),
    showMostReviewedFood: Joi.boolean().allow(),
    showTodaysTrendingFood: Joi.boolean().allow(),
    showPopularRestaurant: Joi.boolean().allow(),
    showNewRestaurant: Joi.boolean().allow(),
    showTiffinSubscriptionPackages: Joi.boolean().allow(),
    showPopularDiningRestaurant: Joi.boolean().allow(),
    showNewDiningRestaurant: Joi.boolean().allow(),

    userAndroidForceUpdateVersion: Joi.string().required(),
    userAndroidUpdateUrl: Joi.string().required(),
    useriOSForceUpdateVersion: Joi.string().required(),
    useriOSUpdateUrl: Joi.string().required(),

    vendorAndroidForceUpdateVersion: Joi.string().required(),
    vendorAndroidUpdateUrl: Joi.string().required(),
    vendoriOSForceUpdateVersion: Joi.string().required(),
    vendoriOSUpdateUrl: Joi.string().required(),

    deliveryManAndroidForceUpdateVersion: Joi.string().required(),
    deliveryManAndroidUpdateUrl: Joi.string().required(),
    deliveryManiOSForceUpdateVersion: Joi.string().required(),
    deliveryManiOSUpdateUrl: Joi.string().required(),

    waiterAndroidForceUpdateVersion: Joi.string().required(),
    waiterAndroidUpdateUrl: Joi.string().required(),
    waiteriOSForceUpdateVersion: Joi.string().required(),
    waiteriOSUpdateUrl: Joi.string().required(),

    kitchenAndroidForceUpdateVersion: Joi.string().required(),
    kitchenAndroidUpdateUrl: Joi.string().required(),
    kitcheniOSForceUpdateVersion: Joi.string().required(),
    kitcheniOSUpdateUrl: Joi.string().required(),
  }),
};

const idValidation = {
  params: Joi.object().keys({
    id: Joi.string().custom(objectId),
  }),
};

module.exports = {
  createOrUpdateAppWebSettings,
  idValidation,
};
