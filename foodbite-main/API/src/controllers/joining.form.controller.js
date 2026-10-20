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
const { joiningFormService } = require('../services');

const saveRestaurantForm = catchAsync(async (req, res) => {
  const { formField } = req.body;
  const result = await joiningFormService.saveRestaurantForm(formField);
  res.send(result);
});

const saveDeliverymanForm = catchAsync(async (req, res) => {
  const { formField } = req.body;
  const result = await joiningFormService.saveDeliverymanForm(formField);
  res.send(result);
});

const getRestaurantForm = catchAsync(async (req, res) => {
  const result = await joiningFormService.getRestaurantForm();
  res.send(result);
});

const getDeliverymanForm = catchAsync(async (req, res) => {
  const result = await joiningFormService.getDeliverymanForm();
  res.send(result);
});

module.exports = {
  saveRestaurantForm,
  saveDeliverymanForm,
  getRestaurantForm,
  getDeliverymanForm,
};
