sap.ui.define([
	"sap/ui/core/mvc/Controller",
	// "sap/sync/ui5training/controller/BaseController",
	"sap/ui/core/UIComponent",
	"sap/m/MessageToast"
], function (Controller, UIComponent, MessageToast) {
	"use strict";

	return Controller.extend("b02.sd.common.sdorder1.controller.View2", {
		onInit: function () {
			this.bus = this.getOwnerComponent().getEventBus();
			
		},

		onBeforeRendering:function(){
			
		
		},
		
		
		
		getRouter : function () {
			return UIComponent.getRouterFor(this);
		},

		handleNavigateToFirstColumn: function () {
			this.bus.publish("flexible", "setMasterPage");

			
		},
		handleNavigateToLastColumn: function () {
			this.bus.publish("flexible", "setDetailDetailPage");
		},

		onTest: function(){
			debugger;
		}
		
	
	});
});