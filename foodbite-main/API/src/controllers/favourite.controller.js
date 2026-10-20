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
const { favouriteService } = require('../services');

const saveFavourite = catchAsync(async (req, res) => {
  const favourite = await favouriteService.saveFavourite(req.body);
  res.send(favourite);
});

const getFavouriteRestaurants = catchAsync(async (req, res) => {
  const options = pick(req.body, ['sortBy', 'limit', 'page']);
  const restaurants = await favouriteService.getFavouriteRestaurnats(
    req.body.latitude,
    req.body.longitude,
    req.body.uid,
    options
  );
  res.send(restaurants);
});

const getFavouriteFoods = catchAsync(async (req, res) => {
  const options = pick(req.body, ['sortBy', 'limit', 'page']);
  const foods = await favouriteService.getFavouriteFoods(
    req.body.latitude,
    req.body.longitude,
    req.body.uid,
    options
  );
  res.send(foods);
});

const deleteFavouriteRestaurant = catchAsync(async (req, res) => {
  await favouriteService.deleteFavouriteRestaurant(req.params.restaurantId, req.params.userId);
  res.send({ success: true });
});

const deleteFavouriteFood = catchAsync(async (req, res) => {
  await favouriteService.deleteFavouriteFood(req.params.foodId, req.params.userId);
  res.send({ success: true });
});

const customerAllFavourite = catchAsync(async (req, res) => {
  const options = pick(req.query, ['user', 'limit', 'page']);
  const result = await favouriteService.customerAllFavourite(options);
  res.send(result);
});

const customerFavouriteOrders = catchAsync(async (req, res) => {
  const options = pick(req.query, ['user', 'limit', 'page']);
  const result = await favouriteService.customerFavouriteOrders(options);
  res.send(result);
});

const customerFavouriteRestaurant = catchAsync(async (req, res) => {
  const options = pick(req.query, ['user', 'limit', 'page']);
  const result = await favouriteService.customerFavouriteRestaurant(options);
  res.send(result);
});

const customerFavouriteFood = catchAsync(async (req, res) => {
  const options = pick(req.query, ['user', 'limit', 'page']);
  const result = await favouriteService.customerFavouriteFood(options);
  res.send(result);
});

module.exports = {
  saveFavourite,
  getFavouriteRestaurants,
  getFavouriteFoods,
  deleteFavouriteRestaurant,
  deleteFavouriteFood,
  customerAllFavourite,
  customerFavouriteOrders,
  customerFavouriteRestaurant,
  customerFavouriteFood,
};
