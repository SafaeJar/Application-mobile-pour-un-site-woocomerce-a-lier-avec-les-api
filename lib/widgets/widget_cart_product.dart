import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:woocommerce/models/cart_response_model.dart';
import 'package:woocommerce/provider/cart_provider.dart';
import 'package:woocommerce/provider/loader_provider.dart';
import 'package:woocommerce/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce/provider/loader_provider.dart';
import 'package:woocommerce/provider/cart_provider.dart';

import '../utils/custom_stepper.dart';

class CartProduct extends StatelessWidget {
  CartProduct({this.data});
  CartItem data;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: makeListTitle(context),
      ),
    );
  }

  ListTile makeListTitle(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        leading: Container(
          width: 50,
          height: 150,
          alignment: Alignment.center,
          child: Image.network(
            data.thumbnail,
            height: 150,
          ),
        ),
        title: Padding(
          padding: EdgeInsets.all(5),
          child: Text(
            data.variationId == 0
                ? data.productName
                : "${data.productName}(${data.attributeValue})${data.attributeValue}",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.all(5),
          child: Wrap(
            direction: Axis.vertical,
            children: [
              Text(
                "${data.productRegularPrice.toString()} dh",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: FlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 20,
                      ),
                      Text(
                        "Remove",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    Utils.showMessage(
                      context,
                      'grocery App',
                      'do you want to delete that item',
                      "yes",
                      () {
                        Provider.of<LoaderProvider>(context, listen: false)
                            .setLoadingStatus(true);

                        Provider.of<CartProvider>(context, listen: false)
                            .removeItem(data.productId);

                        Provider.of<LoaderProvider>(context, listen: false)
                            .setLoadingStatus(false);

                        Navigator.of(context).pop();
                      },
                      buttonText2: "No",
                      isConfirmationDialog: true,
                      onPressed2: () {
                        Navigator.of(context).pop();
                      },
                    );
                  },
                  padding: EdgeInsets.all(8),
                  color: Colors.redAccent,
                  shape: StadiumBorder(),
                ),
              )
            ],
          ),
        ),
        trailing: Container(
          width: 120,
          child: CustomStepper(
            lowerLimit: 0,
            upperLimit: 20,
            stepValue: 1,
            iconSize: 22.0,
            value: data.qty,
            onChanged: (value) {
              Provider.of<CartProvider>(context, listen: false).updateQty(
                  data.productId, value,
                  variationId: data.variationId);
            },
          ),
        ),
      );
}
