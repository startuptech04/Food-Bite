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
const pick = require('../utils/pick');
const { notificationListService } = require('../services');

const get = catchAsync(async (req, res) => {
  const { user } = req.params;
  const result = await notificationListService.getMyNotificationCount(user);
  res.send(result);
});

const getMyNotificationList = catchAsync(async (req, res) => {
  const { user } = req.body;
  const options = pick(req.body, ['sortBy', 'limit', 'page']);
  const result = await notificationListService.getMyNotificationList(user, options);
  res.send(result);
});

const readAllNotification = catchAsync(async (req, res) => {
  const { user } = req.params;
  const result = await notificationListService.notificationReadAllStatus(user);
  res.send(result);
});

const adminHeaderContent = catchAsync(async (req, res) => {
  const result = await notificationListService.adminHeaderContent();
  res.send(result);
});

const adminNotificationList = catchAsync(async (req, res) => {
  const options = pick(req.query, ['sortBy', 'limit', 'page']);
  const result = await notificationListService.adminNotificationList(options);
  res.send(result);
});

const accountantHeaderContent = catchAsync(async (req, res) => {
  const result = await notificationListService.accountantHeaderContent();
  res.send(result);
});

const vendorHeaderContent = catchAsync(async (req, res) => {
  const { id } = req.params;
  const result = await notificationListService.vendorHeaderContent(id);
  res.send(result);
});

const supportTeamHeaderContent = catchAsync(async (req, res) => {
  const { id } = req.params;
  const result = await notificationListService.supportTeamHeaderContent(id);
  res.send(result);
});

const cityzenHeaderContent = catchAsync(async (req, res) => {
  const { id } = req.params;
  const result = await notificationListService.cityzenHeaderContent(id);
  res.send(result);
});

const cityzenNotificationList = catchAsync(async (req, res) => {
  const { id } = req.params;
  const options = pick(req.query, ['sortBy', 'limit', 'page']);
  const result = await notificationListService.cityzenNotificationList(id, options);
  res.send(result);
});

module.exports = {
  get,
  getMyNotificationList,
  readAllNotification,
  adminHeaderContent,
  adminNotificationList,
  accountantHeaderContent,
  vendorHeaderContent,
  supportTeamHeaderContent,
  cityzenHeaderContent,
  cityzenNotificationList,
};
