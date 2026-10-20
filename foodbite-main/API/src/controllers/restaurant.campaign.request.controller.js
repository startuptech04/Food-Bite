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
const { restaurantCampaignRequestService } = require('../services');

const requestCampaign = catchAsync(async (req, res) => {
  const result = await restaurantCampaignRequestService.requestCampaign(req.body);
  res.send(result);
});

const get = catchAsync(async (req, res) => {
  const options = pick(req.query, ['sortBy', 'limit', 'page']);
  const result = await restaurantCampaignRequestService.getList(req.params.campaignId, options);
  res.send(result);
});

const drop = catchAsync(async (req, res) => {
  await restaurantCampaignRequestService.deleteRequestById(req.params.campaignId);
  res.send({ success: true });
});

module.exports = {
  requestCampaign,
  get,
  drop,
};
