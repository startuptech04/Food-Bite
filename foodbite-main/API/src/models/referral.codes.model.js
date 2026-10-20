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
const otpGenerator = require('otp-generator');
const { toJSON, paginate } = require('./plugins');

const referralCodeSchema = mongoose.Schema(
  {
    holderId: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'User',
      required: true,
    },
    code: {
      type: String,
    },
    status: {
      type: Boolean,
      default: true,
    },
  },
  {
    timestamps: true,
  }
);

// add plugin that converts mongoose to json & convert to unique slug
referralCodeSchema.plugin(toJSON);
referralCodeSchema.plugin(paginate);

referralCodeSchema.statics.isUserExist = async function (holderId, excludeUserId) {
  const referralCode = await this.findOne({ holderId, _id: { $ne: excludeUserId } });
  return !!referralCode;
};

referralCodeSchema.pre('save', async function () {
  const referralCode = this;
  referralCode.code = otpGenerator.generate(10, {
    digits: true,
    upperCaseAlphabets: true,
    lowerCaseAlphabets: false,
    specialChars: false,
  });
});

/**
 * @typedef ReferralCode
 */
const ReferralCode = mongoose.model('ReferralCode', referralCodeSchema);

module.exports = ReferralCode;
