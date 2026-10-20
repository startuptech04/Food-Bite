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

const { OrderDeliveryProof } = require('../models');

const saveProof = async (proof) => {
  const checkExist = await OrderDeliveryProof.findOne({ orderId: proof.orderId });
  if (checkExist) {
    const proofData = {
      orderId: proof.orderId,
      pickup:
        proof !== null && proof.pickup !== null && proof.pickup !== '' ? proof.pickup : 'none',
      dropup:
        proof !== null && proof.dropup !== null && proof.dropup !== '' ? proof.dropup : 'none',
    };
    if (proof.type === 'pick') {
      delete proofData.dropup;
    } else {
      delete proofData.pickup;
    }
    Object.assign(checkExist, proofData);
    await checkExist.save();
    return { success: true };
  }

  const proofData = new OrderDeliveryProof({
    orderId: proof.orderId,
    pickup: proof !== null && proof.pickup !== null && proof.pickup !== '' ? proof.pickup : 'none',
    dropup: proof !== null && proof.dropup !== null && proof.dropup !== '' ? proof.dropup : 'none',
  });
  await OrderDeliveryProof.create(proofData);
  return { success: true };
};

module.exports = {
  saveProof,
};
