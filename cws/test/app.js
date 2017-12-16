/* global require */

var expect = require("chai").expect;

console.isEhanced = true;
var test = null;

/* Test suite for app library */
describe("Application core component", function () {
    describe("app object", function () {
        test = require("../core/app");
        it("should be an object", function () {
            expect(test).to.be.an('object');
        });
    });
});