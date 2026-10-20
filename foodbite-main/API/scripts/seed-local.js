/**
 * FoodBite – Multi Restaurant Food Delivery App
 * (NodeJS, MongoDB, Angular & Flutter)
 *
 * Copyright © 2026 Elitecanyon InfoTech (https://www.elitecanyon.com/)
 * Licensed under the Envato Market License.
 */

const mongoose = require('mongoose');
const config = require('../src/config/config');
const Language = require('../src/models/languages.model');
const BusinessSettings = require('../src/models/bussiness.settings.model');
const UserSettings = require('../src/models/user.settings.model');
const City = require('../src/models/city.model');
const Cuisine = require('../src/models/cuisine.model');
const Category = require('../src/models/category.model');
const Restaurant = require('../src/models/restaurant.model');
const RestaurantSettings = require('../src/models/restaurant.settings.model');
const OrderSettings = require('../src/models/order.settings.model');
const PaymentConfig = require('../src/models/payment.config.model');
const Food = require('../src/models/food.model');
const AppWebSetting = require('../src/models/app.web.settings.model');

const seedLocalDatabase = async () => {
  await mongoose.connect(config.mongoose.url, config.mongoose.options);

  if ((await Language.countDocuments()) === 0) {
    await Language.create({
      name: 'English',
      nativeName: 'English',
      image: 'local-english.png',
      code: 'en',
      direction: 'ltr',
      isDefault: true,
      status: true,
    });
    console.info('Created the default English language');
  }

  if ((await BusinessSettings.countDocuments()) === 0) {
    await BusinessSettings.create({
      companyName: 'FoodBite Local',
      email: 'local@example.test',
      mobile: '+10000000000',
      country: 'United States',
      address: 'Local development',
      timezone: {
        value: 'UTC',
        abbr: 'UTC',
        offset: '+00:00',
        isdst: 'false',
        text: '(UTC+00:00) Coordinated Universal Time',
        utc: ['UTC'],
      },
      timeFormat: '12',
      defaultCountryCode: {
        name: 'United States',
        dial_code: '+1',
        code: 'US',
        flag: '',
      },
      currency: {
        cc: 'USD',
        symbol: '$',
        name: 'US Dollar',
      },
      currencySide: 'left',
      decimalPoint: 2,
      cookiesText: 'Local development only',
      deliveryChargeAmount: 0,
      logo: 'local-logo.png',
      favicon: 'local-favicon.png',
      deliveryArea: 25,
      guestCheckout: true,
      websiteUrl: 'http://127.0.0.1:8080/',
      maintenance: false,
    });
    console.info('Created minimal local business settings');
  }

  const businessSettings = await BusinessSettings.findOne();
  if (businessSettings) {
    let settingsUpdated = false;
    if (!businessSettings.foodTaxName) {
      businessSettings.foodTaxName = 'Tax';
      settingsUpdated = true;
    }
    if (!businessSettings.foodTaxType) {
      businessSettings.foodTaxType = 'per';
      settingsUpdated = true;
    }
    if (!businessSettings.additionalServiceName) {
      businessSettings.additionalServiceName = 'Service charge';
      settingsUpdated = true;
    }
    if (settingsUpdated) {
      await businessSettings.save();
      console.info('Completed local checkout business settings');
    }
  }

  if ((await UserSettings.countDocuments()) === 0) {
    await UserSettings.create({
      userLoginWith: 'email_password',
      userResetPasswordWith: 'email_otp',
      signUpVerification: false,
    });
    console.info('Created default local customer settings');
  }

  if ((await OrderSettings.countDocuments()) === 0) {
    await OrderSettings.create({
      homeDelivery: true,
      takeaway: true,
      scheduleDelivery: true,
      instantOrder: true,
      customerCanOrderWithinDays: 5,
      timeIntervalForScheduleDelivery: { value: 30, type: 'min' },
    });
    console.info('Created local customer order settings');
  }

  if (!(await RestaurantSettings.findOne())) {
    await RestaurantSettings.create({
      havePackagingCharges: false,
      includePackagesChargesInTax: false,
      packagingCharges: 0,
      packagingChargesTax: 0,
    });
    console.info('Created local restaurant order settings');
  }

  if (!(await PaymentConfig.findOne({ status: true }))) {
    await PaymentConfig.create({
      name: 'Cash on Delivery',
      slug: 'local-cash-on-delivery',
      image: 'local-cash-on-delivery.png',
      credentials: {},
      isDefault: true,
      paymentWay: 'offline',
      status: true,
    });
    console.info('Created local cash-on-delivery payment method');
  }

  let appWebSetting = await AppWebSetting.findOne();
  if (!appWebSetting) {
    appWebSetting = await AppWebSetting.create({
      showPopularFood: true,
      showMostReviewedFood: true,
      showTodaysTrendingFood: true,
      showPopularRestaurant: true,
      showNewRestaurant: true,
      showTiffinSubscriptionPackages: false,
      userAndroidForceUpdateVersion: '0.0.1',
      userAndroidUpdateUrl: 'https://play.google.com/store/apps',
      useriOSForceUpdateVersion: '0.0.1',
      useriOSUpdateUrl: 'https://apps.apple.com/',
    });
    console.info('Created local customer home settings');
  } else {
    let settingsUpdated = false;
    if (!appWebSetting.userAndroidForceUpdateVersion) {
      appWebSetting.userAndroidForceUpdateVersion = '0.0.1';
      settingsUpdated = true;
    }
    if (!appWebSetting.userAndroidUpdateUrl) {
      appWebSetting.userAndroidUpdateUrl = 'https://play.google.com/store/apps';
      settingsUpdated = true;
    }
    if (!appWebSetting.useriOSForceUpdateVersion) {
      appWebSetting.useriOSForceUpdateVersion = '0.0.1';
      settingsUpdated = true;
    }
    if (!appWebSetting.useriOSUpdateUrl) {
      appWebSetting.useriOSUpdateUrl = 'https://apps.apple.com/';
      settingsUpdated = true;
    }
    if (settingsUpdated) {
      await appWebSetting.save();
      console.info('Completed local customer app version settings');
    }
  }

  let city = await City.findOne({ name: 'Melbourne' });
  if (!city) {
    city = await City.create({
      name: 'Melbourne',
      image: 'local-city.png',
      location: { type: 'Point', coordinates: [144.9631, -37.8136] },
      status: true,
    });
    console.info('Created the local Melbourne service area');
  }

  let cuisine = await Cuisine.findOne({ name: 'Local Favorites' });
  if (!cuisine) {
    cuisine = await Cuisine.create({
      name: 'Local Favorites',
      image: 'local-cuisine.png',
      status: true,
    });
    console.info('Created the local demo cuisine');
  }

  let category = await Category.findOne({ name: 'Local Menu' });
  if (!category) {
    category = await Category.create({
      name: 'Local Menu',
      image: 'local-category.png',
      status: true,
    });
    console.info('Created the local demo menu category');
  }

  let restaurant = await Restaurant.findOne({ name: 'FoodBite Test Kitchen' });
  if (!restaurant) {
    restaurant = await Restaurant.create({
      userId: new mongoose.Types.ObjectId(),
      name: 'FoodBite Test Kitchen',
      address: '100 Demo Street, Melbourne VIC 3000',
      shortDescription: 'A sample restaurant for local checkout testing.',
      cuisine: [cuisine._id],
      category: [],
      logo: 'local-logo.png',
      cover: 'local-cover.png',
      city: city._id,
      location: { type: 'Point', coordinates: [144.9631, -37.8136] },
      type: 'commission',
      approxDeliveryTime: '25-35 min',
      dishPriceForTwo: 25,
      restaurantType: [],
      restaurantFacility: [],
      minOrderAmount: 0,
      status: true,
      temporaryClosed: false,
      acceptHomeDelivery: true,
    });
    console.info('Created the local demo restaurant');
  }

  if (!restaurant.slots || restaurant.slots.length === 0) {
    restaurant.slots = Array.from({ length: 7 }, (_, day) => ({
      day,
      times: [{ start: '12:00 AM', end: '11:59 PM' }],
    }));
    await restaurant.save();
    console.info('Configured all-day local restaurant availability');
  }

  const menu = [
    {
      name: 'Classic Cheeseburger',
      shortDescription: 'Grilled beef, cheddar, lettuce, and house sauce.',
      price: 12.5,
      foodType: 'nonveg',
    },
    {
      name: 'Garden Veggie Bowl',
      shortDescription: 'Seasonal vegetables, grains, and lemon dressing.',
      price: 10.5,
      foodType: 'veg',
    },
    {
      name: 'Crispy Fries',
      shortDescription: 'Golden fries with a pinch of sea salt.',
      price: 5,
      foodType: 'veg',
    },
  ];

  for (const item of menu) {
    if (!(await Food.exists({ restaurant: restaurant._id, name: item.name }))) {
      await Food.create({
        ...item,
        image: 'local-food.png',
        restaurant: restaurant._id,
        category: category._id,
        status: 'live',
        inStock: true,
        variations: [],
      });
      console.info(`Added local menu item: ${item.name}`);
    }
  }

  await Food.updateMany(
    { restaurant: restaurant._id, $or: [{ category: { $exists: false } }, { category: null }] },
    { $set: { category: category._id } }
  );
};

seedLocalDatabase()
  .catch((error) => {
    console.error('Failed to seed the local database:', error);
    process.exitCode = 1;
  })
  .finally(async () => {
    await mongoose.disconnect();
  });
