sap.ui.define([
	"sap/ui/core/mvc/Controller",
    "sap/ui/core/routing/History",
	"sap/ui/model/json/JSONModel", 
	"sap/m/MessageToast",
	"sap/m/MessageBox"
], function (Controller, History, JSONModel, MessageToast, MessageBox) {
	"use strict";

	return Controller.extend("b02.sd.common.sdorder1.controller.View3", {
		onInit: function () {
			this.bus = this.getOwnerComponent().getEventBus();

			var oData = {
				sToday : "Today", //value는 string	
				dateFormat : "yyyy-MM-dd",
				VendorData : [],
				orderDate : new Date()
			};
			var oModel = new JSONModel(oData);
			this.getView().setModel(oModel, "view2");
		},
		handleNavigateToMidColumnPress: function () {
			this.bus.publish("flexible", "setDetailPage");
		},
		onBeforeRendering: function(){
            this._getData();
        },
        _getData: function(){
            var oDataModel = this.getView().getModel();
            var oViewModel = this.getView().getModel("view2");
			
        oDataModel.read("/VendorListSet",{
            success: function (oData) {

                var oProductData = oData.results;
        
                oViewModel.setProperty("/VendorData", oProductData);
				
            }.bind(this),
            error: function (oError){
                console.log(oError);
            }})
        },
		onSelectDate : function (oEvent) { 
			MessageToast.show(oEvent.getSource().getValue());
			var oViewModel = this.getView().getModel("view2");
			var oOrderDate = oEvent.getSource().getValue();
        
			oViewModel.setProperty("/orderDate", oOrderDate);
			// debugger
		},

		onDebugger : function () {
			this.getView().byId('ShoppingCartWizard').setShowNextButton()
			debugger;
		},
		onAccept : function() {
			var oItems = this.getView().getModel("myModel").getProperty("/cart");
			// var i = '주문이 완료되었습니다.'
			// MessageToast.show(i);
			var aHeaderToItem = oItems.map(function(list) {
				return {
					Prodcd: list.Matrc,
					Itemprice: list.iResult.toString(),
					Itemqty: list.Quantity,					
					}
				}
				

				)
				
				
				
				
				// Plant: "",
					// Cmpnc: "",
					// Vendorc: "",
					// Saleym: "",
					// Ordercd: "",
					// Prodcd: list.Matrc,
					// Boxunit: "",
					// Itemprice: list.iResult,
					// Waers: "",
					// Itemweight: "",
					// Weightunit: "",
					// Itemqty: list.Quantity

			// 	}
			// })
			    //    success : function(){
				// 			var i = '주문이 완료되었습니다.'
				// 			MessageToast.show(i);},
				// 		error: function(error){
				// 			console.log(error);
				// 		}})

			// var aHeaderToItem = [1].map(function() {
			// 	return {
			// 		Plant: "1000",
			// 		Cmpnc: "1004",
			// 		Vendorc: "008",
			// 		Saleym: "202210",
			// 		Ordercd: "CB1001",
			// 		Prodcd: "CP1001",
			// 		Boxunit: "EA",
			// 		Itemprice: "1000",
			// 		Waers: "KRW",
			// 		Itemweight: "100",
			// 		Weightunit: "KG",
			// 		Itemqty: "100"
			// 	}
			// })

// <Property Name="Plant" Type="Edm.String" Nullable="false" MaxLength="4" sap:unicode="false" sap:label="Plant" sap:creatable="false" sap:updatable="false" sap:sortable="false" sap:filterable="false"/>
// <Property Name="Cmpnc" Type="Edm.String" Nullable="false" MaxLength="4" sap:unicode="false" sap:label="회사코드" sap:creatable="false" sap:updatable="false" sap:sortable="false" sap:filterable="false"/>
// <Property Name="Vendorc" Type="Edm.String" Nullable="false" MaxLength="3" sap:unicode="false" sap:label="판매처 코드" sap:creatable="false" sap:updatable="false" sap:sortable="false" sap:filterable="false"/>
// <Property Name="Saleym" Type="Edm.String" Nullable="false" MaxLength="7" sap:unicode="false" sap:label="매출년월" sap:creatable="false" sap:updatable="false" sap:sortable="false" sap:filterable="false"/>
// <Property Name="Ordercd" Type="Edm.String" Nullable="false" MaxLength="20" sap:unicode="false" sap:label="주문번호" sap:creatable="false" sap:updatable="false" sap:sortable="false" sap:filterable="false"/>
// <Property Name="Prodcd" Type="Edm.String" Nullable="false" MaxLength="6" sap:unicode="false" sap:label="제품코드" sap:creatable="false" sap:updatable="false" sap:sortable="false" sap:filterable="false"/>
// <Property Name="Boxunit" Type="Edm.String" Nullable="false" MaxLength="3" sap:unicode="false" sap:label="출고단위" sap:creatable="false" sap:updatable="false" sap:sortable="false" sap:filterable="false" sap:semantics="unit-of-measure"/>
// <Property Name="Itemprice" Type="Edm.Decimal" Nullable="false" Precision="21" Scale="3" sap:unicode="false" sap:unit="Waers" sap:label="항목 별 금액" sap:creatable="false" sap:updatable="false" sap:sortable="false" sap:filterable="false"/>
// <Property Name="Waers" Type="Edm.String" Nullable="false" MaxLength="5" sap:unicode="false" sap:label="화폐 단위" sap:creatable="false" sap:updatable="false" sap:sortable="false" sap:filterable="false" sap:semantics="currency-code"/>
// <Property Name="Itemweight" Type="Edm.Decimal" Nullable="false" Precision="10" Scale="0" sap:unicode="false" sap:unit="Weightunit" sap:label="항목 별 무게" sap:creatable="false" sap:updatable="false" sap:sortable="false" sap:filterable="false"/>
// <Property Name="Weightunit" Type="Edm.String" Nullable="false" MaxLength="3" sap:unicode="false" sap:label="무게 단위" sap:creatable="false" sap:updatable="false" sap:sortable="false" sap:filterable="false" sap:semantics="unit-of-measure"/>
// <Property Name="Itemqty" Type="Edm.Decimal" Nullable="false" Precision="8" Scale="0" sap:unicode="false" sap:unit="Boxunit" sap:label="항목 별 수량" sap:creatable="false" sap:updatable="false" sap:sortable="false" sap:filterable="false"/>
			var oOrderDate = this.byId("datePicker").getDateValue();
			var iUTCDate = oOrderDate.getTime() - oOrderDate.getTimezoneOffset()*60*1000;
			var oData = {
				// 헤더필드,
				Ordercd : "",
				Duedate : "/Date(" + iUTCDate + ")/",
				// Duedate : String('20221102'),
				HeaderToItem : aHeaderToItem
			};
			console.log(oItems)
			var oModel = this.getView().getModel();
			var sPath = "/SellHeaderSet";

			// debugger;

			// var oData = {
			// 	"Ordercd": "12",
			// 	 "HeaderToItem":[{
			// 		"Ordercd":"12",
			// 		"Prodcd":"CP0001"
			// 	}]
			// }
			// oModel.create(
			// 	sPath,
			// 	oData,
			// 	{
			// 		success: function() {
			// 			debugger;
			// 		},
			// 		error: function() {
			// 			debugger;
			// 		}
			// 	}
			// )

			$.ajax({ 
				type: "POST",
				url: "/sap/opu/odata/sap/ZGWB02FOODSD_SRV" + sPath,
				data: JSON.stringify(oData),
				dataType: "json",
				async: false,
				contentType: 'application/json; charset=utf-8',
				success: function(data, textStatus, xhr){        
					// debugger;
					console.log("sukses: "+data+" "+JSON.stringify(xhr));
				},
				error: function (e,xhr,textStatus,err,data) {
					console.log(e);
					console.log(xhr);
					console.log(textStatus);
					console.log(err);
					debugger
				}
			}); 

			// oModel.create(sPath, oData, {
			// 	success : function(){
			// 			var i = '주문이 완료되었습니다.'
			// 			MessageToast.show(i);},
			// 		error: function(error){
			// 			console.log(error);
			// 		}})
			// oModel.createEntry(sPath, {properties:oData} );

			// oModel.submitChanges({
			// 	success : function(){
			// 		var i = '주문이 완료되었습니다.'
			// 		MessageToast.show(i);},
			// 	error: function(error){
			// 		console.log(error);
			// 	}
			// });

			MessageBox.information("주문 정보 상세보기",{
				title: "주문이 완료되었습니다.",
				id: "messageBoxId1",
				details: 
				// this.getView().getModel('view2').oData.VendorData[0]	
				"<p><strong>고객 정보 및 배송지</strong></p>\n" +
				// "<ul>" +
				"<li>" + this.getView().getModel('view2').oData.VendorData[0].Repr + "</li>" + 
				"<li>" + this.getView().getModel('view2').oData.VendorData[0].Vendorn + "</li>" + 
				"<li>" + this.getView().getModel('view2').oData.VendorData[0].Ploc + "</li>" + 
				"<li>" + this.getView().getModel('view2').oData.VendorData[0].Phone + "</li>" + 
				"<li>" + this.getView().getModel('view2').oData.VendorData[0].Email + "</li>" + 
				// "</ul>" +
				// "<p>Get more help <a href='//www.sap.com' target='_top'>here</a>." +

				"<p><strong>주문 정보</strong></p>\n" +
				// "<ul>" +
				"<li>" + 
				this.getView().getModel('myModel').oData.cart[0].Matrnm + 
						" 등 " + 
						this.getView().getModel('myModel').oData.cart.length +
						"개   " + 
						this.getView().getModel('Compo').oData.sTotal +
				"</li>" +
				// "</ul>" +

				"<p><strong>배송 요청일</strong></p>\n" +
				"<li>" + this.getView().getModel('view2').oData.orderDate + "</li>"
			}
			
			);
			
			
		},
		onReject : function() {
			var j = '취소되었습니다.'
			MessageToast.show(j);
			this.bus.publish("flexible", "setDetailPage");
			
		},
		onShowTextInfo: function () {
			MessageBox.information("주문 정보 상세보기",{
				title: "주문이 완료되었습니다.",
				id: "messageBoxId1",
				details: 
				// this.getView().getModel('view2').oData.VendorData[0]	
				"<p><strong>고객 정보 및 배송지</strong></p>\n" +
				// "<ul>" +
				"<li>" + this.getView().getModel('view2').oData.VendorData[0].Repr + "</li>" + 
				"<li>" + this.getView().getModel('view2').oData.VendorData[0].Vendorn + "</li>" + 
				"<li>" + this.getView().getModel('view2').oData.VendorData[0].Ploc + "</li>" + 
				"<li>" + this.getView().getModel('view2').oData.VendorData[0].Phone + "</li>" + 
				"<li>" + this.getView().getModel('view2').oData.VendorData[0].Email + "</li>" + 
				// "</ul>" +
				// "<p>Get more help <a href='//www.sap.com' target='_top'>here</a>." +

				"<p><strong>주문 정보</strong></p>\n" +
				// "<ul>" +
				"<li>" + 
				this.getView().getModel('myModel').oData.cart[0].Matrnm + 
						" 등 " + 
						this.getView().getModel('myModel').oData.cart.length +
						"개   " + 
						this.getView().getModel('Compo').oData.sTotal +
				"</li>" +
				// "</ul>" +

				"<p><strong>배송 요청일</strong></p>\n" +
				"<li>" + this.getView().getModel('view2').oData.orderDate + "</li>"
			}
			
			);
		},
		onShowFormattedTextInfo: function () {
			MessageBox.error("Unable to load data.", {
				title: "Error",
				id: "messageBoxId2",
				details: "<p><strong>This can happen if:</strong></p>\n" +
					"<ul>" +
					"<li>You are not connected to the internet</li>" +
					"<li>a backend component is not <em>available</em></li>" +
					"<li>or an underlying system is down</li>" +
					"</ul>" +
					"<p>Get more help <a href='//www.sap.com' target='_top'>here</a>.",
				contentWidth: "100px",
				styleClass: sResponsivePaddingClasses
			});
			
		},
	});
});