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

const { SocialSignin } = require('../models');

const saveSignin = async (param) => {
  return SocialSignin.create(param);
};

const getSocialSignin = async () => {
  return SocialSignin.findOne();
};

const getSignInById = async (id) => {
  return SocialSignin.findById(id);
};

const updateSignIn = async (id, param) => {
  const socialSignin = await getSignInById(id);
  Object.assign(socialSignin, param);
  await socialSignin.save();
  return socialSignin;
};

const publicSocialSignin = async () => {
  const settings = await SocialSignin.findOne(
    {},
    { appleSignin: 1, facebookSignin: 1, googleSignin: 1, id: 1, configCredsRaw: 1 }
  );
  const appSetting = {
    appleSignin: false,
    facebookSignin: false,
    googleSignin: false,
    googleOAuth: {
      google_client_id: '',
      google_server_id: '',
    },
  };
  if (settings !== null && settings.id !== '' && settings.id !== null) {
    appSetting.appleSignin = settings.appleSignin;
    appSetting.googleSignin = settings.googleSignin;
    appSetting.facebookSignin = settings.facebookSignin;
    const googleCreds = settings.configCredsRaw;
    if (
      googleCreds !== null &&
      googleCreds.google_client_id !== null &&
      googleCreds.google_client_id !== ''
    ) {
      appSetting.googleOAuth.google_client_id = googleCreds.google_client_id;
      appSetting.googleOAuth.google_server_id = googleCreds.google_server_id;
    }
  }
  return appSetting;
};

module.exports = {
  saveSignin,
  getSocialSignin,
  updateSignIn,
  publicSocialSignin,
};
