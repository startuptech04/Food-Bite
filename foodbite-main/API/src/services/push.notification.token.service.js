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

const { PushNotificationToken } = require('../models');

const savePushNotificationToken = async (param) => {
  const checkTokenData = await PushNotificationToken.findOne({ token: param.token });
  if (checkTokenData) {
    const notificationData = {
      user: param && param.user && param.user !== null && param.user !== '' ? param.user : null,
      token:
        param && param.token && param.token !== null && param.token !== '' ? param.token : null,
      deviceId:
        param && param.deviceId && param.deviceId !== null && param.deviceId !== ''
          ? param.deviceId
          : null,
      deviceType:
        param && param.deviceType && param.deviceType !== null && param.deviceType !== ''
          ? param.deviceType
          : null,
    };
    Object.assign(checkTokenData, notificationData);
    await checkTokenData.save();
    return { success: true };
  }
  const notificationData = new PushNotificationToken({
    user: param && param.user && param.user !== null && param.user !== '' ? param.user : null,
    token: param && param.token && param.token !== null && param.token !== '' ? param.token : null,
    deviceId:
      param && param.deviceId && param.deviceId !== null && param.deviceId !== ''
        ? param.deviceId
        : null,
    deviceType:
      param && param.deviceType && param.deviceType !== null && param.deviceType !== ''
        ? param.deviceType
        : null,
  });
  await PushNotificationToken.create(notificationData);
  return { success: true };
};

const updatePushNotificationToken = async (param) => {
  const checkTokenData = await PushNotificationToken.findOne({ token: param.token });
  if (checkTokenData) {
    const notificationData = {
      user: param && param.user && param.user !== null && param.user !== '' ? param.user : null,
      token:
        param && param.token && param.token !== null && param.token !== '' ? param.token : null,
      deviceId:
        param && param.deviceId && param.deviceId !== null && param.deviceId !== ''
          ? param.deviceId
          : null,
      deviceType:
        param && param.deviceType && param.deviceType !== null && param.deviceType !== ''
          ? param.deviceType
          : null,
    };
    Object.assign(checkTokenData, notificationData);
    await checkTokenData.save();
    return { success: true };
  }
  return { success: false };
};

module.exports = {
  savePushNotificationToken,
  updatePushNotificationToken,
};
