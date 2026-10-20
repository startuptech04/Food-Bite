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

const { Visitor } = require('../models');

const saveVisitor = async (param) => {
  const visitorData = new Visitor({
    ipAddress: param.ipAddress,
    userAgent: param.userAgent,
  });
  const tracking = await Visitor.create(visitorData);
  return { success: true, id: tracking.id };
};

const getTrackingId = async (param) => {
  const tracking = await Visitor.findOne({
    ipAddress: param.ipAddress,
    userAgent: param.userAgent,
  });
  if (!tracking || tracking.id === null || tracking.id === '') {
    const visitorData = new Visitor({
      ipAddress: param.ipAddress,
      userAgent: param.userAgent,
    });
    const newTracking = await Visitor.create(visitorData);
    return { success: true, id: newTracking.id };
  }
  return { success: true, id: tracking.id };
};

module.exports = {
  saveVisitor,
  getTrackingId,
};
