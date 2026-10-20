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
const { smsProviderConfigService } = require('../services');

const create = catchAsync(async (req, res) => {
  const result = await smsProviderConfigService.createConfig(req.body);
  res.send(result);
});

const update = catchAsync(async (req, res) => {
  const result = await smsProviderConfigService.updateSmsProviderConfig(req.params.slug, req.body);
  res.send(result);
});

const get = catchAsync(async (req, res) => {
  const result = await smsProviderConfigService.getSmsProviderBySlug(req.params.slug);
  res.send(result);
});

const sendTwilioDemoSMS = catchAsync(async (req, res) => {
  const { mobile, locale } = req.body;
  const result = await smsProviderConfigService.sendTwilioDemoSMS(mobile, locale);
  res.send(result);
});

const sendNexmoDemoSMS = catchAsync(async (req, res) => {
  const { mobile, locale } = req.body;
  const result = await smsProviderConfigService.sendNexmoDemoSMS(mobile, locale);
  res.send(result);
});

const sendSMStoDemoSMS = catchAsync(async (req, res) => {
  const { mobile, locale } = req.body;
  const result = await smsProviderConfigService.sendSMStoDemoSMS(mobile, locale);
  res.send(result);
});

const send2FactorDemoSMS = catchAsync(async (req, res) => {
  const { mobile, locale } = req.body;
  const result = await smsProviderConfigService.send2FactorDemoSMS(mobile, locale);
  res.send(result);
});

module.exports = {
  create,
  update,
  get,
  sendTwilioDemoSMS,
  sendNexmoDemoSMS,
  sendSMStoDemoSMS,
  send2FactorDemoSMS,
};
