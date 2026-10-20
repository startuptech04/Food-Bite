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

const _ = require('lodash');
const { AppPage } = require('../models');

const createPage = async (param) => {
  const result = await AppPage.create(param);
  return result;
};

const getPageBySlug = async (slugURL) => {
  const result = await AppPage.findOne({ slug: slugURL });
  return result;
};

const getPageContent = async (slugURL) => {
  const result = await AppPage.findOne(
    { slug: slugURL },
    { description: 1, _id: 0, translations: 1 }
  );
  return result;
};

const getContent = async (slugURL) => {
  const result = await AppPage.findOne(
    { slug: slugURL },
    { description: 1, _id: 0, translations: 1 }
  );
  if (result !== null && result.description !== null) {
    const decodedTranslations = (result.translations || []).map((t) => ({
      ...t,
      value: _.unescape(t.value || ''),
    }));
    return {
      success: true,
      content: _.unescape(result.description),
      translations: decodedTranslations,
    };
  }
  return {
    success: true,
    content: '<h1>Hello World!</h1>',
    translations: [],
  };
};

const updatePage = async (slug, param) => {
  const result = await getPageBySlug(slug);

  Object.assign(result, param);
  await result.save();
  return result;
};

module.exports = {
  createPage,
  getPageBySlug,
  updatePage,
  getPageContent,
  getContent,
};
