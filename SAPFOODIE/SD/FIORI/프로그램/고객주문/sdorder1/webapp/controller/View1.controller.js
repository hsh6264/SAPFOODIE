sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/model/json/JSONModel",
    "sap/m/MessageToast" 
    ],function(Controller, JSONModel, MessageToast) {
        "use strict";
    return Controller.extend("b02.sd.common.sdorder1.controller.View1", {
       
        onInit: function( ) {
            this.bus = this.getOwnerComponent().getEventBus();
            var oData = {
              
            ProductData : [],
            oCart : [],
            oTotal : null,
            oSdprice : []
            };

            var oModel = new JSONModel(oData);
            this.getView().setModel(oModel, "view");
        },
        onBeforeRendering: function(){
            this._getData();
        },
        _getData: function(){
            var oDataModel = this.getView().getModel();
            var oViewModel = this.getView().getModel("view");

        oDataModel.read("/ProductListSet",{
            success: function (oData) {

                var oProductData = oData.results;
                var iLength = oProductData.length;
                var iPrice = 0;
                var sPrice = null;

                for( var i = 0; i < iLength; i++ ){
                    var sPath = "b02/sd/common/sdorder1/images/" + oProductData[i].Matrc + ".jpg";
                    oProductData[i].image = sap.ui.require.toUrl(sPath);
                    iPrice = oProductData[i].Sdprice
                    sPrice = String(iPrice);

                    if(sPrice.length > 3 && sPrice.length < 7){
                        var iNum = sPrice.length -3; 
                        oProductData[i].Price = sPrice.substring(0,iNum) + ',' + sPrice.slice(-3) + "원";
                    }
                                          
                }
        
                oViewModel.setProperty("/ProductData", oProductData);
   
            },
            error: function (oError){
                console.log(oError);
            }})
        },
        handleNavigateToMidColumnPress: function () {
            this.bus.publish("flexible", "setDetailPage");
            
        },
        onInCart: function(){
        var oTable =  this.getView().byId("products");
        var itemIndex = oTable.indexOfItem(oTable.getSelectedItem());
        var oCompoModel = this.getOwnerComponent().getModel('Compo');

        var oProductsModel = this.getView().getModel("view");
        
        var aSelecteditems = [];
        if(itemIndex !== -1) {
            var oItems = oTable.getSelectedItems();

            for(var i=0; i<oItems.length; i++){
                var sData = oItems[i].getBindingContextPath();

                if(oProductsModel.getProperty(sData).iResult){
                    aSelecteditems.push(oProductsModel.getProperty(sData));
                };
                
            }
            this.getOwnerComponent().getModel("myModel").setProperty("/cart", aSelecteditems, null, true);
        } 

        var aCart   = this.getOwnerComponent().getModel("myModel").oData.cart
        var iLength = aCart.length;
        var iTotal  = 0;
        var sTotal  = null;

        for(var ii=0; ii<iLength; ii++){
            iTotal += aCart[ii].iResult;
        };

        sTotal = String(iTotal);
        if(sTotal.length > 3 && sTotal.length < 7){
            var iiNum = sTotal.length - 3;
            sTotal = sTotal.substring(0,iiNum) + ',' + sTotal.slice(-3);
        } else if(sTotal.length > 6 && sTotal.length < 10){
            var iiNum = sTotal.length - 6;
            sTotal = sTotal.substring(0,iiNum) + ',' + sTotal.substring(iiNum, iiNum+3) + ',' + sTotal.slice(-3); 
        }

        sTotal = '총합: ' + sTotal + ' 원'

        oCompoModel.setProperty('/sTotal', sTotal);
        
        var msg = "장바구니에 담았습니다.";
        MessageToast.show(msg);   
    },
    onLiveChange: function(oEvent){
        
        var oViewModel = this.getView().getModel("view");  // 모델불러오기
        var iIndex = oEvent.oSource.oParent.sId.slice(-1); //oEvent가 발생한 index 
        var oProductData = oViewModel.getProperty('/ProductData'); // 제이슨 모델을 불러옴

        var sResult = null;  
        var iLength = oProductData.length;
       

        oProductData[iIndex].iResult = parseInt(oProductData[iIndex].Quantity) * parseInt(oProductData[iIndex].Sdprice);
        
        // debugger;

        for(var i=0; i<iLength; i++){
            sResult = String(oProductData[i].iResult);
                if(sResult == 'undefined'){
                    sResult = '';
                }
                else{
                    if(sResult.length > 3 && sResult.length < 7){
                    var iNum = sResult.length -3;
                    sResult = sResult.substring(0,iNum) + ',' 
                            + sResult.slice(-3) + '원';
                }else if(sResult.length > 6 && sResult.length < 10){
                    var iNum = sResult.length - 6;
                    sResult = sResult.substring(0,iNum) + ',' 
                            + sResult.substring(iNum,iNum+3) + ',' 
                            + sResult.slice(-3) + '원';
                }else if(sResult.length > 11 && sResult.length < 15){
                    var iNum = sResult.length - 9;
                    sResult = sResult.substring(0,iNum) + ',' 
                            + sResult.substring(iNum,iNum+3) + ',' 
                            + sResult.substring(iNum+3,iNum+6) + ',' 
                            + sResult.slice(-3) + '원';
                }else if(sResult = 'undefined'){
                    sResult = ''
                }
                }

                
                
                
            oProductData[i].sResult = sResult;
        }
        oViewModel.setProperty('/oProductData', oProductData);
        // if(oProductData[iIndex].iResult.length > 3 && oProductData[iIndex].iResult.length <7){
        //     var iNum = oProductData[iIndex].iResult.length -3;
        //     oProductData[iIndex].iResult = oProductData[iIndex].iResult.substring(0,iNum) + ',' +
        //     oProductData[iIndex].iResult.length.slice(-3);
        // }


        // 선택한 행의 iResult 값 = 선택한 행의 Quantity * 선택한 행의 Sdprice.

        // if(oProductData[iIndex].iResult.length > 3 && oProductData[iIndex].iResult/length < 7){
        //     var iNum = oProductData[iIndex].iResult.length -3;
        //     oProductData[iIndex].iResult
        // } 
        
        oViewModel.setProperty('/ProductData', oProductData); //ProductData 값을 변경된 값이 든 모델로 세팅 
      

    },

    onTest: function(){
        var oViewModel = this.getView().getModel('view');
        debugger;
    }
    
    })
});