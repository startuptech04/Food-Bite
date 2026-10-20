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

const catchAsync = require('../utils/catchAsync');
const {
  languageService,
  businessSettingsService,
  userSettingService,
  driverSettingsService,
  socialSigninService,
  waiterSettingService,
  visitorService,
  restaurantSettingsService,
  appWebSettingService,
  kitchenOwnerSettingService,
  mediaStorageSettingService,
} = require('../services');

const getDefaultSettings = catchAsync(async (req, res) => {
  const { agent, userTrackingId } = req.body;
  const ip = req.connection.remoteAddress;
  let tracking;
  if (userTrackingId === null || userTrackingId === '') {
    const visitorTrackingParam = {
      ipAddress: ip,
      userAgent: agent,
    };
    tracking = await visitorService.saveVisitor(visitorTrackingParam);
  } else {
    const visitorTrackingParam = {
      ipAddress: ip,
      userAgent: agent,
    };
    tracking = await visitorService.getTrackingId(visitorTrackingParam);
  }
  const languages = await languageService.getPublicLanguages();
  const businessSettings = await businessSettingsService.getPublicBusinessSettings();
  const language = await languageService.getDefaultLanguage();
  const userSettings = await userSettingService.getUserSettingsPublic();
  const socialSignin = await socialSigninService.publicSocialSignin();
  const driverSettings = await driverSettingsService.driverSelfRegistration();
  const vendorSettings = await restaurantSettingsService.vendorSelfRegistration();
  const selfRegisterStatus = {
    driver: !!(
      driverSettings &&
      driverSettings !== null &&
      driverSettings.selfRegistration === true
    ),
    vendor: !!(
      vendorSettings &&
      vendorSettings !== null &&
      vendorSettings.selfRegistration === true
    ),
  };
  const appVersion = await appWebSettingService.userAppVersionDetail();
  const imagePath = await mediaStorageSettingService.getFilePathUrl();
  res.send({
    locales: languages,
    settings: businessSettings,
    defaultLocale: language,
    user: userSettings,
    social: socialSignin,
    selfRegister: selfRegisterStatus,
    versions: appVersion,
    tracking,
    imagePath,
  });
});

const getDefaultWebSettings = catchAsync(async (req, res) => {
  const languages = await languageService.getPublicLanguages();
  const businessSettings = await businessSettingsService.getPublicBusinessSettings();
  const language = await languageService.getDefaultLanguage();
  const userSettings = await userSettingService.getUserSettingsPublic();
  const driverSettings = await driverSettingsService.driverSelfRegistration();
  const vendorSettings = await restaurantSettingsService.vendorSelfRegistration();
  const selfRegisterStatus = {
    driver: !!(
      driverSettings &&
      driverSettings !== null &&
      driverSettings.selfRegistration === true
    ),
    vendor: !!(
      vendorSettings &&
      vendorSettings !== null &&
      vendorSettings.selfRegistration === true
    ),
  };
  const vendor = await restaurantSettingsService.getVendorSettings();
  const imagePath = await mediaStorageSettingService.getFilePathUrl();
  res.send({
    locales: languages,
    settings: businessSettings,
    defaultLocale: language,
    user: userSettings,
    selfRegister: selfRegisterStatus,
    vendor,
    imagePath,
  });
});

const getDriverDefaultSettings = catchAsync(async (req, res) => {
  const languages = await languageService.getPublicLanguages();
  const businessSettings = await businessSettingsService.getPublicBusinessSettings();
  const language = await languageService.getDefaultLanguage();
  const driverSettings = await driverSettingsService.driverPublicSettings();
  const socialSignin = await socialSigninService.publicSocialSignin();
  const appVersion = await appWebSettingService.deliverymanAppVersionDetail();
  const imagePath = await mediaStorageSettingService.getFilePathUrl();
  res.send({
    locales: languages,
    settings: businessSettings,
    defaultLocale: language,
    driver: driverSettings,
    social: socialSignin,
    versions: appVersion,
    imagePath,
  });
});

const getWaiterDefaultSettings = catchAsync(async (req, res) => {
  const languages = await languageService.getPublicLanguages();
  const businessSettings = await businessSettingsService.getPublicBusinessSettings();
  const language = await languageService.getDefaultLanguage();
  const waiterSettings = await waiterSettingService.getSettings();
  const socialSignin = await socialSigninService.publicSocialSignin();
  const appVersion = await appWebSettingService.waiterAppVersionDetail();
  const imagePath = await mediaStorageSettingService.getFilePathUrl();
  res.send({
    locales: languages,
    settings: businessSettings,
    defaultLocale: language,
    waiter: waiterSettings,
    social: socialSignin,
    versions: appVersion,
    imagePath,
  });
});

const getKitchenDefaultSettings = catchAsync(async (req, res) => {
  const languages = await languageService.getPublicLanguages();
  const businessSettings = await businessSettingsService.getPublicBusinessSettings();
  const language = await languageService.getDefaultLanguage();
  const kitchenSettings = await kitchenOwnerSettingService.getSettings();
  const socialSignin = await socialSigninService.publicSocialSignin();
  const appVersion = await appWebSettingService.kitchenAppVersionDetail();
  const imagePath = await mediaStorageSettingService.getFilePathUrl();
  res.send({
    locales: languages,
    settings: businessSettings,
    defaultLocale: language,
    kitchen: kitchenSettings,
    social: socialSignin,
    versions: appVersion,
    imagePath,
  });
});

const publicHeaderContent = catchAsync(async (req, res) => {
  const languages = await languageService.getPublicLanguages();
  res.send({ languages, success: true });
});

module.exports = {
  getDefaultSettings,
  getDefaultWebSettings,
  getDriverDefaultSettings,
  getWaiterDefaultSettings,
  getKitchenDefaultSettings,
  publicHeaderContent,
};
