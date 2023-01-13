import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:woocommerce/models/payment_method.dart';
import 'package:woocommerce/pages/checkout_base.dart';

class PaymentMethodsWidget extends CheckoutBasePage {


  @override
  _PaymentMethodsWidgetState createState() => _PaymentMethodsWidgetState();
}

class _PaymentMethodsWidgetState 
extends CheckoutBasePageState<PaymentMethodsWidget> {
  PaymentMethodList list;
  @override
  void initState(){
    super.initState();
    this.currentPage=1;
  }

  @override
 Widget pageUI(){
list = new PaymentMethodList(context);



return SingleChildScrollView(
  child:Column(

  ) ,);



 }
}