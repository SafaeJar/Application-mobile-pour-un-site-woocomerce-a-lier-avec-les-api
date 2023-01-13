import 'package:flutter/src/widgets/framework.dart';

class PaymentMethod {
  String id;
  String name;
  String description;
  String logo;
  String route;
  Function onTap;
  bool isRouteRedirect;

  PaymentMethod(this.id, this.name, this.description, this.logo, this.route,
      this.onTap, this.isRouteRedirect);
}

class PaymentMethodList {
  List<PaymentMethod> _paymentsList;
  List<PaymentMethod> _cashList;

  PaymentMethodList(BuildContext context) {
    this._paymentsList = [
      PaymentMethod(
        "razorpay",
        "Razorpay",
        "Click to pay with bKash",
        "assets/img/razorpay.png",
        "/razorpay",
        () {},
        false,
      ),
      PaymentMethod(
        "Paypal",
        "Paypal",
        "Click to pay with Paypal",
        "assets/img/Paypal.png",
        "/Paypal",
        () {},
        true,
      ),
    ];
    this._cashList = [
      new PaymentMethod(
        "cod",
        "Cash On Delivery",
        "Click to pay Cash On Delivery",
        "assets/img/cash.png",
        "/OrderSuccess",
        () {},
        false,
      ),
    ];
  }

 List<PaymentMethod> get paymentsList => _paymentsList;
  List<PaymentMethod> get cashList => _cashList;
}
