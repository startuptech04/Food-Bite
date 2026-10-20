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

const express = require('express');
const appAuth = require('../../middlewares/appAuth');
const webAuth = require('../../middlewares/webAuth');
const FileController = require('../../controllers/file.controller');

const router = express.Router();

router.post('/uploadImage', appAuth('uploadImage'), FileController.uploadImage);
router.post('/web_upload_image', webAuth('uploadImage'), FileController.uploadImage);

module.exports = router;
