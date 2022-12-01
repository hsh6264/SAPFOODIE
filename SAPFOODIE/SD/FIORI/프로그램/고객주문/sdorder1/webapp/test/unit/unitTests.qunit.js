/* global QUnit */
QUnit.config.autostart = false;

sap.ui.getCore().attachInit(function () {
	"use strict";

	sap.ui.require([
		"b02sdcommon/sdorder1/test/unit/AllTests"
	], function () {
		QUnit.start();
	});
});
