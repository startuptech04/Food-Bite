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

const { GuestUserInfo } = require('../models');

const checkRegister = async (ip, agent) => {
  const data = await GuestUserInfo.findOne({ ipAddress: ip, userAgent: agent });
  return data;
};

const saveGuestMeta = async (body) => {
  const gestMeta = new GuestUserInfo({
    user: body.uid,
    ipAddress: body.ip,
    userAgent: body.agent,
  });
  return GuestUserInfo.create(gestMeta);
};

module.exports = {
  checkRegister,
  saveGuestMeta,
};
