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

const { status: httpStatus } = require('http-status');
const { EmailTemplate, EmailConfig } = require('../models');
const ApiError = require('../utils/ApiError');

const createEmailTemplate = async (param) => {
  const result = await EmailTemplate.create(param);
  return result;
};

const updateEmailTemplate = async (slugURL, param) => {
  const emailTemplate = await EmailTemplate.findOne({ slug: slugURL });
  if (!emailTemplate) {
    throw new ApiError(httpStatus.BAD_REQUEST, 'Not found');
  }
  Object.assign(emailTemplate, param);
  await emailTemplate.save();
  return emailTemplate;
};

const adminEmailContent = async (slugURL) => {
  const template = await EmailTemplate.findOne({ slug: slugURL });
  const media = await EmailConfig.findOne({}, { mediaUrls: 1 });
  return { template, media };
};

module.exports = {
  createEmailTemplate,
  updateEmailTemplate,
  adminEmailContent,
};
