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
const { toJSON, paginate } = require('./plugins');

const supportChatRoomSchema = mongoose.Schema(
  {
    userId: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'User',
      required: true,
    },
    supportTeam: [
      {
        type: mongoose.SchemaTypes.ObjectId,
        ref: 'User',
        required: true,
      },
    ],
    orders: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'Orders',
      required: false,
    },
    booking: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'DiningBooking',
      required: false,
    },
    purchaseSubscription: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'UserPurchasedTiffinSubscription',
      required: false,
    },
    complaints: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'Complaints',
      required: false,
    },
    reportIssue: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'ReportIssueRestaurant',
      required: false,
    },
    restaurantComplaints: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'RestaurantComplaints',
      required: false,
    },
    supportType: {
      type: String,
      required: true,
      default: 'orders', // orders, dining, tiffin_subscription, complaints, reports,restaurant_complaints
    },
    lastMessage: {
      type: String,
      required: false,
    },
    lastMessageType: {
      type: String,
      required: false,
    },
    resolvedBy: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'User',
      required: false,
    },
    status: {
      type: String,
      default: 'open', // open, in_progress, resolved
    },
  },
  {
    timestamps: true,
    toJSON: { getters: true },
  }
);

// add plugin that converts mongoose to json & convert to unique slug
supportChatRoomSchema.plugin(toJSON);
supportChatRoomSchema.plugin(paginate);

/**
 * @typedef SupportChatRoom
 */
const SupportChatRoom = mongoose.model('SupportChatRoom', supportChatRoomSchema);

module.exports = SupportChatRoom;
