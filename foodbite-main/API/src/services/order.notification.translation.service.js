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

const { OrderNotificationTranslation } = require('../models');

const saveOrderNotificationTranslation = async (notificationBody) => {
  const checkExist = await OrderNotificationTranslation.findOne({ slug: notificationBody.slug });
  if (checkExist) {
    const notificationData = {
      title: notificationBody.title,
      description: notificationBody.description,
      slug: notificationBody.slug,
      translations: notificationBody.translations,
    };
    Object.assign(checkExist, notificationData);
    await checkExist.save();
    return { success: true };
  }

  const notificationData = new OrderNotificationTranslation({
    title: notificationBody.title,
    description: notificationBody.description,
    slug: notificationBody.slug,
    translations: notificationBody.translations,
  });
  await OrderNotificationTranslation.create(notificationData);
  return { success: true };
};

const getBySlug = async (slugURL) => {
  const info = await OrderNotificationTranslation.findOne({ slug: slugURL });
  if (!info) {
    return { success: false };
  }
  return { info, success: true };
};

module.exports = {
  saveOrderNotificationTranslation,
  getBySlug,
};
