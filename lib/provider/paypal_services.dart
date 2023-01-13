import 'dart:convert' ;
import 'dart:convert' as convert;

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce/models/cart_response_model.dart';
import 'dart:async';
import '../config.dart';
import 'cart_provider.dart';

class PaypalServices{
  String clientId= Config.paypalClientID;
  String secret = Config.paypalSecretKey;
  String returnURL= 'return.http://www.fawaido.com/';
  String cancelURL ='cancel.http://www.fawaido.com/';

Future<String> getAccessToken()async{
  try{
    var authToken = base64.encode(
    utf8.encode(clientId+":"+secret),
  );
var response = await Dio().post(
  '${Config.paypalURL}/v1/oauth2/token?grant_type=client_credentials',
  options: new Options(
    headers:{
      HttpHeaders.authorizationHeader: 'Basic $authToken',
      HttpHeaders.contentTypeHeader: "application/json",
    },
  ),
);
if(response.statusCode==200){
  final body= response.data;
  return body["access_token"];
}
return null;
} catch(e){
  rethrow;
}

}

Map<dynamic, dynamic> defaultCurrency={
  "symbol": "INR",
  "decimalDigits":2,
  "symbolBeforeTheNumber": true,
  "currency": "INR",
};


Map<String,dynamic> getOrderParams(BuildContext context){
  var cartModel = Provider.of<CartProvider>(context, listen: false);
  cartModel.fetchCartItems();

List items=[];
cartModel.cartItems.forEach((CartItem item){
items.add({
"name": item.productName,
"quantity":item.qty,
"price":item.productSalePrice,
"currency":defaultCurrency["currency"]



});

});

String totalAmount = cartModel.totalAmount.toString();
String subTotalAmount = cartModel.totalAmount.toString();
String shippingCost='0';
int shippingDiscountCost= 0;

Map<String, dynamic> temp={
  "intent": "sale",
  "payer":{"payment_method":"paypal"},
  "transactions":[
    {
      "amount":{
        "total": totalAmount,
        "currency": defaultCurrency["currency"],
        "details":{
          "subtotal": subTotalAmount,
          "shipping": shippingCost,
          "shipping_discount":((-1.0)*shippingDiscountCost).toString()

        }
      },
"description":"The payment transaction description",
"payment_options":{
  "allowed_payment_method":"INSTANT_FUINDING_SOURCE"
},
"item_list":{
  "items":items,
}
}
  ],
  "note_to_payer":"contact us for any question on your order",
  "redirect_urls":{"return_url":returnURL,"cancel_url":cancelURL}
};
return temp;
}
   Future<Map<String, String>> createPaypalPayment(
  transactions,
  accessToken,
) async{
  try {
    var response= await Dio().post(
"${Config.paypalURL}/v1/payments/payment",
data: convert.jsonEncode(transactions),
options: new Options(
  headers: {
    HttpHeaders.authorizationHeader: 'Brearer $accessToken',
    HttpHeaders.contentTypeHeader : "application/json",
  },
),
);
    final body = response.data;

    if(response.statusCode==201){
      if(body["links"]!=null && body["links"].length> 0){
    List links = body["links"];
    String executeUrl = "";
    String approvalUrl = "";
    final item = links.firstWhere((o) => o["rel"]=="approval_url",
    orElse: ()=>null);
    if(item!=null){
      approvalUrl=item["href"];
    }
    final item1= links.firstWhere((o) =>o["rel"]=="execute",
    orElse: ()=>null);
    if(item1!=null){
      executeUrl= item["href"];
    }
    return {"executeUrl1": executeUrl, "approvalUrl": approvalUrl};
}
return null;
    }
else{
  throw Exception(body["message"]);
}
    } catch (e) {
  rethrow;
}   

  }

Future <String> executePayment(
  url,
  payerId,
  accessToken,
)async{
  try{
    var response =await Dio().post(
      url,
    data: convert.jsonEncode({"payed_id": payerId}),
    options: new Options(
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        HttpHeaders.contentTypeHeader: "application/json",
      },
    ),
    );

final body= response.data;
if(response.statusCode==200){
  return body["id"];


  }
  return null;
}
catch(e){
  rethrow; 
}




  }
}



  



