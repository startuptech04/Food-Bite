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

const { LandingPage } = require('../models');

const getContent = async () => {
  const result = await LandingPage.findOne({});
  return { result, success: true };
};

const saveHeroContent = async (param) => {
  const detail = await LandingPage.findOne();
  if (detail) {
    const obj = {
      heroContent: param,
    };
    Object.assign(detail, obj);
    await detail.save();
  } else {
    await LandingPage.create({ heroContent: param });
  }

  return { success: true };
};

const saveServiceContent = async (param) => {
  const detail = await LandingPage.findOne();
  if (detail) {
    const obj = {
      serviceContent: param,
    };
    Object.assign(detail, obj);
    await detail.save();
  } else {
    await LandingPage.create({ serviceContent: param });
  }

  return { success: true };
};

const saveFaqsContent = async (param) => {
  const detail = await LandingPage.findOne();
  if (detail) {
    const obj = {
      faqContent: param,
    };
    Object.assign(detail, obj);
    await detail.save();
  } else {
    await LandingPage.create({ faqContent: param });
  }

  return { success: true };
};

const saveReviewContent = async (param) => {
  const detail = await LandingPage.findOne();
  if (detail) {
    const obj = {
      reviewContent: param,
    };
    Object.assign(detail, obj);
    await detail.save();
  } else {
    await LandingPage.create({ reviewContent: param });
  }

  return { success: true };
};

const saveScanQrContent = async (param) => {
  const detail = await LandingPage.findOne();
  if (detail) {
    const obj = {
      scanQrContent: param,
    };
    Object.assign(detail, obj);
    await detail.save();
  } else {
    await LandingPage.create({ scanQrContent: param });
  }

  return { success: true };
};

const saveAppFeaturesContent = async (param) => {
  const detail = await LandingPage.findOne();
  if (detail) {
    const obj = {
      appFeatureContent: param,
    };
    Object.assign(detail, obj);
    await detail.save();
  } else {
    await LandingPage.create({ appFeatureContent: param });
  }

  return { success: true };
};

const saveProjectFeaturesContent = async (param) => {
  const detail = await LandingPage.findOne();
  if (detail) {
    const obj = {
      featureContent: param,
    };
    Object.assign(detail, obj);
    await detail.save();
  } else {
    await LandingPage.create({ featureContent: param });
  }

  return { success: true };
};

module.exports = {
  getContent,
  saveHeroContent,
  saveServiceContent,
  saveFaqsContent,
  saveReviewContent,
  saveScanQrContent,
  saveAppFeaturesContent,
  saveProjectFeaturesContent,
};
