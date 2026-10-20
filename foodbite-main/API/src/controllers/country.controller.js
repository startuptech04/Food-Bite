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
const { countryService } = require('../services');

const create = catchAsync(async (req, res) => {
  const result = await countryService.createCountry(req.body);
  res.send(result);
});

const get = catchAsync(async (req, res) => {
  const filter = pick(req.query, ['name']);
  const options = pick(req.query, ['sortBy', 'limit', 'page']);
  const result = await countryService.getAllCountries(filter, options);
  res.send(result);
});

const update = catchAsync(async (req, res) => {
  const result = await countryService.updateCountryById(req.params.countryId, req.body);
  res.send(result);
});

const drop = catchAsync(async (req, res) => {
  await countryService.deleteCountryById(req.params.countryId);
  res.send({ success: true });
});

module.exports = {
  create,
  get,
  update,
  drop,
};
