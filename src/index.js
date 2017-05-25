/*jslint node: true, bitwise: true */
'use strict';

const Api = require('thingworx-api').Api;
const Thing = require('thingworx-api').Thing;
const logger = require('thingworx-utils').Logger;

var config;
var api;

api = new Api(config);
api.on('connect', () => console.log('CONNECTED TO THE THINGWORX'));
api.on('disconnect', msg => console.log('DISCONNECTED FROM THE THINGWORX: %s', msg);
