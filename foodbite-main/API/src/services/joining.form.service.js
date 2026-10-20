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

const { JoiningForm } = require('../models');

const saveRestaurantForm = async (params) => {
  const result = await JoiningForm.findOne();
  if (!result) {
    const form = new JoiningForm({ restaurantForm: params });
    await form.save();
  }
  if (result && result !== null && result.id) {
    const updateBody = { restaurantForm: params };
    Object.assign(result, updateBody);
    await result.save();
  }
  return { success: true };
};

const saveDeliverymanForm = async (params) => {
  const result = await JoiningForm.findOne();
  if (!result) {
    const form = new JoiningForm({ deliverymanForm: params });
    await form.save();
  }
  if (result && result !== null && result.id) {
    const updateBody = { deliverymanForm: params };
    Object.assign(result, updateBody);
    await result.save();
  }
  return { success: true };
};

const getRestaurantForm = async () => {
  const result = await JoiningForm.findOne({}, { restaurantForm: 1 });
  return { result, success: true };
};

const getDeliverymanForm = async () => {
  const result = await JoiningForm.findOne({}, { deliverymanForm: 1 });
  return { result, success: true };
};

const getRestaurantJoiningField = async () => {
  const result = await JoiningForm.findOne({}, { restaurantForm: 1 });
  let haveField = true;
  if (!result) {
    haveField = false;
  }
  return { result, success: haveField };
};

const getDeliverymanJoiningField = async () => {
  const result = await JoiningForm.findOne({}, { deliverymanForm: 1 });
  let haveField = true;
  if (!result) {
    haveField = false;
  }
  return { result, success: haveField };
};

module.exports = {
  saveRestaurantForm,
  saveDeliverymanForm,
  getRestaurantForm,
  getDeliverymanForm,
  getRestaurantJoiningField,
  getDeliverymanJoiningField,
};
