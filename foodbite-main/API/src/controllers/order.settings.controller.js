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
const {
  orderSettingsService,
  orderCancellationReasonService,
  orderRatingsMessageService,
  invoiceInstructionService,
} = require('../services');

const create = catchAsync(async (req, res) => {
  const result = await orderSettingsService.createSettings(req.body);
  res.send(result);
});

const update = catchAsync(async (req, res) => {
  const result = await orderSettingsService.updateSettingsById(req.params.settingId, req.body);
  res.send(result);
});

const get = catchAsync(async (req, res) => {
  const settings = await orderSettingsService.getSettings();
  const options = pick(req.query, ['sortBy', 'limit', 'page']);
  const reasons = await orderCancellationReasonService.getOrderCancallationListAdmin(options);
  const ratings = await orderRatingsMessageService.getOrderRatingListAdmin(options);
  const invoices = await invoiceInstructionService.getList(options);
  res.send({ settings, reasons, ratings, invoices });
});

const getOrderSettings = catchAsync(async (req, res) => {
  const result = await orderSettingsService.getOrderSettings(
    req.body.userId,
    req.body.restaurant,
    req.body.deliveryAddressId,
    req.body.userLatitude,
    req.body.userLongitude,
    req.body.trackingId
  );
  res.send(result);
});

const posOrderSettings = catchAsync(async (req, res) => {
  const result = await orderSettingsService.posOrderSettings();
  res.send(result);
});

module.exports = {
  create,
  update,
  get,
  getOrderSettings,
  posOrderSettings,
};
