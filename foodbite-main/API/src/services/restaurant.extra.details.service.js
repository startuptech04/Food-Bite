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

const mongoose = require('mongoose');
const { RestaurantExtraDetail } = require('../models');

const saveGuestAvailability = async (id, availability) => {
  const query = { restaurant: new mongoose.Types.ObjectId(id) };
  const options = {
    new: true,
    upsert: true,
    setDefaultsOnInsert: true,
  };
  const updateData = {
    guestAvailability: availability,
  };
  await RestaurantExtraDetail.findOneAndUpdate(query, updateData, options);
  return { success: true };
};

const getGuestAvailability = async (id) => {
  const result = await RestaurantExtraDetail.findOne(
    { restaurant: new mongoose.Types.ObjectId(id) },
    { _id: 1, guestAvailability: 1 }
  );
  if (!result) {
    return { success: false };
  }
  return { result, success: true };
};

const getMyDiningSchedule = async (id) => {
  const result = await RestaurantExtraDetail.findOne(
    { restaurant: new mongoose.Types.ObjectId(id) },
    { _id: 1, slots: 1 }
  );
  if (!result) {
    const slots = [
      {
        day: 0, // Monday
        times: [],
      },
      {
        day: 1, // Tuesday
        times: [],
      },
      {
        day: 2, // Wednesday
        times: [],
      },
      {
        day: 3, // Thursday
        times: [],
      },
      {
        day: 4, // Friday
        times: [],
      },
      {
        day: 5, // Saturday
        times: [],
      },
      {
        day: 6, // Sunday
        times: [],
      },
    ];
    return { slots, success: true };
  }
  let { slots } = result;
  if (slots && slots.length <= 0) {
    slots = [
      {
        day: 0, // Monday
        times: [],
      },
      {
        day: 1, // Tuesday
        times: [],
      },
      {
        day: 2, // Wednesday
        times: [],
      },
      {
        day: 3, // Thursday
        times: [],
      },
      {
        day: 4, // Friday
        times: [],
      },
      {
        day: 5, // Saturday
        times: [],
      },
      {
        day: 6, // Sunday
        times: [],
      },
    ];
  }
  return { slots, success: true };
};

const saveDiningSchedule = async (id, param) => {
  const query = { restaurant: new mongoose.Types.ObjectId(id) };
  const options = {
    new: true,
    upsert: true,
    setDefaultsOnInsert: true,
  };
  const updateData = {
    slots: param.slots,
  };
  await RestaurantExtraDetail.findOneAndUpdate(query, updateData, options);
  return { success: true };
};

const saveDiningScheduleWeb = async (id, param) => {
  const query = { restaurant: new mongoose.Types.ObjectId(id) };
  const options = {
    new: true,
    upsert: true,
    setDefaultsOnInsert: true,
  };
  const updateData = {
    slots: JSON.parse(param.slots),
  };
  await RestaurantExtraDetail.findOneAndUpdate(query, updateData, options);
  return { success: true };
};

module.exports = {
  saveGuestAvailability,
  getGuestAvailability,
  getMyDiningSchedule,
  saveDiningScheduleWeb,
  saveDiningSchedule,
};
