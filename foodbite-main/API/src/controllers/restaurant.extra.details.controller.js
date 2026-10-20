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
const { restaurantExtraDetailsService } = require('../services');

const saveGuestAvailability = catchAsync(async (req, res) => {
  function convertStringToNumberList(numberString) {
    return numberString.split(',').map((num) => parseInt(num.trim(), 10));
  }
  const availabilityList = convertStringToNumberList(req.body.availability);
  const facility = await restaurantExtraDetailsService.saveGuestAvailability(
    req.params.restaurant,
    availabilityList
  );
  res.send(facility);
});

const getGuestAvailability = catchAsync(async (req, res) => {
  const { restaurant } = req.params;
  const result = await restaurantExtraDetailsService.getGuestAvailability(restaurant);
  res.send(result);
});

const getMyDiningSchedule = catchAsync(async (req, res) => {
  const { restaurant } = req.params;
  const result = await restaurantExtraDetailsService.getMyDiningSchedule(restaurant);
  res.send(result);
});

const saveDiningSchedule = catchAsync(async (req, res) => {
  const restaurant = await restaurantExtraDetailsService.saveDiningSchedule(
    req.params.restaurant,
    req.body
  );
  res.send(restaurant);
});

const saveDiningScheduleWeb = catchAsync(async (req, res) => {
  const restaurant = await restaurantExtraDetailsService.saveDiningScheduleWeb(
    req.params.restaurant,
    req.body
  );
  res.send(restaurant);
});

module.exports = {
  saveGuestAvailability,
  getGuestAvailability,
  getMyDiningSchedule,
  saveDiningSchedule,
  saveDiningScheduleWeb,
};
