import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce/config.dart';
import 'package:woocommerce/models/cart_request_model.dart';
import 'package:woocommerce/models/cart_response_model.dart';
import 'package:woocommerce/models/category.dart';
import 'package:woocommerce/models/customer.dart';
import 'package:woocommerce/models/customer_detail_mode.dart';
import 'package:woocommerce/models/login_model.dart';
import 'package:woocommerce/models/order.dart';
import 'package:woocommerce/models/order_detail.dart';
import 'package:woocommerce/models/product.dart';
import 'package:woocommerce/models/variable_product.dart';
import 'package:woocommerce/pages/paypal_payment.dart';
import 'package:woocommerce/pages/verify_address.dart';
import 'package:woocommerce/shared_service.dart';
import 'package:woocommerce/widgets/widget_order_success.dart';

import '../color_constants.dart';
import '../provider/cart_provider.dart';
import '../provider/loader_provider.dart';
import '../utils/ProgressHUD.dart';
import '../widgets/unauth_widget.dart';
import '../widgets/widget_cart_product.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    var cartItemsList = Provider.of<CartProvider>(context, listen: false);
    cartItemsList.resetStreams();
    cartItemsList.fetchCartItems();
  }

  @override
  Widget build(BuildContext context) {
        return new  FutureBuilder(
      future: SharedService.isLoggedIn(),
      builder: (
        BuildContext context,
        AsyncSnapshot<bool> loginModel,
      ) {
        if (loginModel.hasData) {
          if (loginModel.data) {
            return Consumer<LoaderProvider>(
                builder: (context, loaderModel, child) {
              return Scaffold(
          
                body: ProgressHUD(
                  child: _cartItemsList(),
                  inAsyncCall: loaderModel.isApiCallProcess,
                  opacity: 0.3,
                ),
              );
            });
          } else {
            return  UnAuthWidget();
          }
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _cartItemsList() {
    return Consumer<CartProvider>(
      builder: (context, cartModel, child) {
        if (cartModel.cartItems != null && cartModel.cartItems.length > 0) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: cartModel.cartItems.length,
                    itemBuilder: (context, index) {
                      return CartProduct(
                        data: cartModel.cartItems[index],
                      );
                    },
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Icon(
                          Icons.sync,
                          color: ColorConstants.kPrimaryTextColor,
                        ),
                        Text(
                          " Update Cart",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    onPressed: () {
                      Provider.of<LoaderProvider>(context, listen: false)
                          .setLoadingStatus(true);
                      var cartProvider =
                          Provider.of<CartProvider>(context, listen: false);

                      cartProvider.updateCart(
                        (val) {
                          Provider.of<LoaderProvider>(context, listen: false)
                              .setLoadingStatus(false);
                        },
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(15),
                      backgroundColor: ColorConstants.kSecondaryColor,
                      shape: StadiumBorder(),
                    ),
                  ),
                ),
              ),
              Container(
                color: ColorConstants.kPrimaryTextColor,
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //changed from coloumn to row
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total:",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            "${cartModel.totalAmount}dh",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Checkout:",
                              style: TextStyle(
                                  color: ColorConstants.kPrimaryTextColor),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: ColorConstants.kPrimaryTextColor,
                            ),
                          ],
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VerifyAddress(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.all(15),
                          backgroundColor: ColorConstants.kPrimaryLightColor,
                          shape: StadiumBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
  } else {
          return Container(
            child: Text('No Cart Items, Null return'),
          );
        }
      },
    );
  }
}
