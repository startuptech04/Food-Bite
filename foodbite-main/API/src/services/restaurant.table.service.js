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
const { status: httpStatus } = require('http-status');
const { RestaurantTable } = require('../models');
const ApiError = require('../utils/ApiError');

const createTable = async (param) => {
  const saved = await RestaurantTable.findOne({
    restaurant: param.restaurant,
    tableNumber: param.tableNumber,
  });
  if (saved) {
    throw new ApiError(httpStatus.BAD_REQUEST, 'Already exist');
  }
  await RestaurantTable.create(param);
  return { success: true };
};

const getMyTableList = async (vendor, options) => {
  const limit = options.limit && parseInt(options.limit, 10) > 0 ? parseInt(options.limit, 10) : 10;
  const page = options.page && parseInt(options.page, 10) > 0 ? parseInt(options.page, 10) : 1;
  const skip = (page - 1) * limit;
  const query = [
    {
      $match: {
        restaurant: new mongoose.Types.ObjectId(vendor),
      },
    },
    { $sort: { createdAt: -1 } },
    { $skip: skip },
    { $limit: Number(limit) },
    {
      $project: {
        _id: 0,
        id: '$_id',
        tableNumber: 1,
        capacity: 1,
        status: 1,
      },
    },
  ];
  const results = await RestaurantTable.aggregate(query);
  const totalResults = await RestaurantTable.countDocuments({
    restaurant: new mongoose.Types.ObjectId(vendor),
  });
  return Promise.all([results, totalResults]).then(() => {
    const totalPages = Math.ceil(totalResults / limit);
    const result = {
      results,
      page,
      limit,
      totalPages,
      totalResults,
    };
    return Promise.resolve(result);
  });
};

const updateStatus = async (id, param) => {
  const table = await RestaurantTable.findById(id);
  if (!table) {
    throw new ApiError(httpStatus.NOT_FOUND, 'Not found');
  }
  Object.assign(table, param);
  await table.save();
  return { success: true };
};

const updateRestaurantTable = async (id, param) => {
  const table = await RestaurantTable.findById(id);
  if (!table) {
    throw new ApiError(httpStatus.NOT_FOUND, 'Not found');
  }
  Object.assign(table, param);
  await table.save();
  return { success: true };
};

const deleteTable = async (id) => {
  const table = await RestaurantTable.findById(id);
  if (!table) {
    throw new ApiError(httpStatus.NOT_FOUND, 'Not found');
  }
  await table.deleteOne();
  return { success: true };
};

const waiterTableList = async (vendor) => {
  const tableQuery = [
    {
      $match: { restaurant: new mongoose.Types.ObjectId(vendor), status: true },
    },
    {
      $lookup: {
        from: 'tableordercartitems',
        localField: '_id',
        foreignField: 'tableId',
        as: 'tableordercartitems',
      },
    },
    {
      $addFields: {
        occupied: {
          $cond: {
            if: { $eq: [{ $size: '$tableordercartitems' }, 0] },
            then: false,
            else: true,
          },
        },
      },
    },
    {
      $project: {
        _id: 0,
        id: '$_id',
        capacity: 1,
        tableNumber: 1,
        occupied: '$occupied',
      },
    },
  ];
  const tables = await RestaurantTable.aggregate(tableQuery);
  return { tables, success: true };
};

module.exports = {
  createTable,
  getMyTableList,
  updateStatus,
  updateRestaurantTable,
  deleteTable,
  waiterTableList,
};
