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

const winston = require('winston');
const path = require('path');
const fs = require('fs');
const config = require('./config');

const baseLogDir = path.join(process.cwd(), 'logs');
if (!fs.existsSync(baseLogDir)) {
  fs.mkdirSync(baseLogDir);
}

const enumerateErrorFormat = winston.format((info) => {
  if (info instanceof Error) {
    Object.assign(info, { message: info.stack });
  }
  return info;
});

const logFormat = winston.format.combine(
  enumerateErrorFormat(),
  winston.format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }),
  config.env === 'development' ? winston.format.colorize() : winston.format.uncolorize(),
  winston.format.printf(({ timestamp, level, message }) => `${timestamp} ${level}: ${message}`)
);

function getDailyLogFolder() {
  const date = new Date().toISOString().slice(0, 10);
  const folder = path.join(baseLogDir, date);
  if (!fs.existsSync(folder)) {
    fs.mkdirSync(folder);
  }
  return folder;
}

function createTransports() {
  const logFolder = getDailyLogFolder();

  if (config.env === 'production') {
    return [
      new winston.transports.File({
        filename: path.join(logFolder, 'app.log'),
        level: 'info',
      }),
      new winston.transports.File({
        filename: path.join(logFolder, 'error.log'),
        level: 'error',
      }),
    ];
  }

  return [
    new winston.transports.Console({
      stderrLevels: ['error'],
    }),
  ];
}

const logger = winston.createLogger({
  level: config.env === 'development' ? 'debug' : 'info',
  format: logFormat,
  transports: createTransports(),
});

if (config.env === 'production') {
  const todayFolder = getDailyLogFolder();

  logger.exceptions.handle(
    new winston.transports.File({
      filename: path.join(todayFolder, 'exceptions.log'),
    })
  );

  logger.rejections.handle(
    new winston.transports.File({
      filename: path.join(todayFolder, 'rejections.log'),
    })
  );
}

module.exports = logger;
