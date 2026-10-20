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

const adminExpensesType = {
  COUPON: 'coupon',
  FREE_DELIVERY: 'free_delivery',
  WALLET_BONUS: 'wallet_bonus',
  LOYALTY_POINTS: 'loyalty_points',
  DINING_COUPON: 'dining_coupon',
  WALLET_CREDIT_CUSTOMER: 'wallet_credit_customer',
  WALLET_CREDIT_DELIVERYMAN: 'wallet_credit_deliveryman',
  IT_SUPPORT: 'it_support',
  SALES: 'sales_ads',
  EMPLOYEE: 'employees',
  OUTSOURCE: 'outsource_work',
  PAYMENT_GATEWAY: 'payment_gateway_charges',
  OTHERS: 'other',
};

const vendorExpensesType = {
  PRODUCT: 'product',
  COUPON: 'coupon',
  DINING_COUPON: 'dining_coupon',
  REFUND: 'order_refund',
  OTHER: 'other',
};

module.exports = {
  adminExpensesType,
  vendorExpensesType,
};
