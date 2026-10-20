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
const { fcmNotificationService } = require('../services');

const test = catchAsync(async (req, res) => {
  res.send({ ok: true });
});

const adminSendNotification = catchAsync(async (req, res) => {
  const { to, title, description } = req.body;
  const result = await fcmNotificationService.adminSendNotification(to, title, description);
  res.send(result);
});

const cityzenSendNotificaiton = catchAsync(async (req, res) => {
  const { id } = req.params;
  const { to, title, description } = req.body;
  const result = await fcmNotificationService.cityzenSendNotificaiton(id, to, title, description);
  res.send(result);
});

module.exports = {
  test,
  adminSendNotification,
  cityzenSendNotificaiton,
};
