import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:woocommerce/models/cart_request_model.dart';
import 'package:woocommerce/models/login_model.dart';
import 'package:woocommerce/models/product.dart';
import 'package:woocommerce/models/variable_product.dart';
import 'package:woocommerce/provider/cart_provider.dart';
import 'package:woocommerce/provider/loader_provider.dart';
import 'package:woocommerce/utils/custom_stepper.dart';
import 'package:woocommerce/widgets/widget_related_products.dart';

import '../config.dart';
import '../utils/expand_text.dart';



class ProductDetailsWidget extends StatelessWidget {
  ProductDetailsWidget({Key key, this.data, this.variableProducts})
      : super(key: key);

  Product data;
  List<VariableProduct> variableProducts;

  CartProducts cartProducts = new CartProducts();

  final CarouselController _controller = CarouselController();
  @override
  Widget build(BuildContext context) {
    cartProducts.quantity = 1;

    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                productCarousel(this.data.images, context),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: productDetails(context),
                ),
                ExpandText(
                  labelHeader: "Product Details",
                  shortDesc: data.shortDescription,
                  desc: data.desctiption,
                ),
                WidgetRelatedProducts(
                  labelName: "Related Products".toUpperCase(),
                  products: this.data.relatedIds,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget productDetails(context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
        SizedBox(height: 10),
    SizedBox(height: 5),
    Text(
    data.name,
    textAlign: TextAlign.center,
    style: TextStyle(
    fontSize: 25,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    ),
    ),
    Padding(
    padding: const EdgeInsets.only(top: 1.0),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Text(
    "${data.price}",
    textAlign: TextAlign.center,
    style: TextStyle(
    fontSize: 20,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    ),
    ),
    FlatButton(
    child: Row(
    children: [
    Text(
    "Share".toUpperCase(),
    style: TextStyle(
    color: Colors.black,
    fontSize: 12,
    fontWeight: FontWeight.bold,
    ),
    ),
    SizedBox(
    width: 5,
    ),
    Icon(
    Icons.share,
    size: 20,
    color: Colors.black,
    ),
    ],
    ),

    padding: EdgeInsets.all(10),
    color: Colors.white,
    shape: RoundedRectangleBorder(),
    ),
    ],
    ),
    ),
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Visibility(
    visible: data.type != "variable",
    child: Text(
    data.attributes != null && data.attributes.length > 0
    ? (data.attributes[0].name +
    ": " +
    data.attributes[0].options.toString())
        : "",
    textAlign: TextAlign.center,
    style: TextStyle(
    fontSize: 15,
    color: Colors.grey[600],
    fontWeight: FontWeight.w500,
    ),
    ),
    ),
    Visibility(
    visible: data.type == "variable",
    child: dropdown(
    context,
    this.data.variableProduct,
    this.variableProducts,
    (value) {
    print(value.price);
    this.data.price = value.price;
    this.data.variableProduct = value;
    },
    ),
    ),
    ],
    ),
    Text(
    "Availability : ${data.stockStatus}",
    textAlign: TextAlign.center,
    style: TextStyle(
    fontSize: 13,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    ),
    ),
    Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: Text(
    "Product Code : ${data.sku}",
    textAlign: TextAlign.center,
    style: TextStyle(
    fontSize: 13,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    ),
    ),
    ),
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    CustomStepper(
    lowerLimit: 1,
    upperLimit: 20,
    stepValue: 1,
    iconSize: 22.0,
    value: cartProducts.quantity,
    onChanged: (value) {
    cartProducts.quantity = value;
    },
    ),
    FlatButton(
    child: Row(
    children: [
    Icon(
    Icons.shopping_basket,
    color: Colors.white,
    ),
    SizedBox(
    width: 5,
    ),
    Text(
    "Add to Cart",
    style: TextStyle(color: Colors.white),
    ),
    ],
    ),
      onPressed: () {
        Provider.of<LoaderProvider>(context, listen: false)
            .setLoadingStatus(true);
        var cartProvider =
        Provider.of<CartProvider>(context, listen: false);
        cartProducts.productId = data.id;
        cartProducts.variationId = data.variableProduct != null
            ? data.variableProduct.id
            : 0;

        cartProvider.addToCart(
          cartProducts,
              (val) {
            Provider.of<LoaderProvider>(context, listen: false)
                .setLoadingStatus(false);
            print(val);
          },
        );
      },
      padding: EdgeInsets.all(10),
      color: Colors.black,
      shape: RoundedRectangleBorder(),
    ),
    ],
    ),
          SizedBox(height: 15),
        ],
    );
  }

  Widget productCarousel(List<Images> images, BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 250,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Visibility(
              visible: images.length > 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                //alignment: Alignment,
                child: CarouselSlider.builder(
                  itemCount: images.length,
                  options: CarouselOptions(
                    enlargeCenterPage: true,
                    viewportFraction: 1,
                    aspectRatio: 1.0,
                    autoPlay: false,
                  ),
                  itemBuilder: (context, index, rindex) {
                    return Image.network(
                      images[index] != null ? images[index].src : null,
                      fit: BoxFit.fitWidth,
                      width: MediaQuery.of(context).size.width,
                    );

                    // return Container(
                    //   width: MediaQuery.of(context).size.width,
                    //   child: Center(
                    //     child: Image.network(
                    //       images[index] != null ? images[index].src : null,
                    //       fit: BoxFit.fitWidth,
                    //       width: 200,
                    //     ),
                    //   ),
                    // );
                  },
                  carouselController: _controller,
                ),
              ),
            ),
          ),
          Positioned(
            top: 100,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                _controller.previousPage();
              },
            ),
          ),
          Positioned(
            top: 100,
            left: MediaQuery.of(context).size.width - 40,
            child: IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () {
                _controller.nextPage();
              },
            ),
          ),
        ],
      ),
    );
  }

  static Widget selectDropdown(
      BuildContext context,
      Object initialValue,
      dynamic data,
      Function onChanged, {
        Function onValidate,
      }) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        height: 75,
        width: 100,
        padding: EdgeInsets.only(top: 5),
        child: new DropdownButtonFormField<VariableProduct>(
          hint: new Text("Select"),
          //value: null,
          value: (initialValue != "" && initialValue != null)
              ? initialValue
              : null,
          isDense: true,
          decoration: fieldDecoration(context, "", ""),
          onChanged: (VariableProduct newValue) {
            FocusScope.of(context).requestFocus(new FocusNode());
            onChanged(newValue);
          },
          // validator: (value) {
          //   return onValidate(value);
          // },
          items: data != null
              ? data.map<DropdownMenuItem<dynamic>>(
                (dynamic data) {
              return DropdownMenuItem<dynamic>(
                value: data,
                child: new Text(
                  data.attributes.first.option +
                      " " +
                      data.attributes.first.name,
                  style: new TextStyle(color: Colors.black),
                ),
              );
            },
          ).toList()
              : null,
        ),
      ),
    );
  }

  static InputDecoration fieldDecoration(
  BuildContext context,
      String hintText,
  String helperText, {
  Widget prefixIcon,
      Widget suffixIcon,
      }) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(6),
      hintText: hintText,
      helperText: helperText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1,
        ),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1,
        ),
      ),
    );
  }

  static Widget dropdown(
      BuildContext context,
      dynamic initialValue,
      dynamic data,
      Function onChanged, {
        Function onValidate,
      }) {
    var _value = data == null && initialValue == null
        ? initialValue
        : initialValue != null
        ? data.firstWhere((item) => item.id == initialValue.id)
        : null;

    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        height: 75,
        width: 100,
        padding: EdgeInsets.only(top: 2),
        child: new DropdownButtonFormField<dynamic>(
          hint: new Text("Select"),
          value: _value,
          isDense: true,
          isExpanded: true,
          decoration: fieldDecoration(context, "", ""),
          onChanged: (dynamic newValue) {
            FocusScope.of(context).requestFocus(new FocusNode());
            onChanged(newValue);
          },
          items: data != null
              ? data.map<DropdownMenuItem<dynamic>>(
                (dynamic data) {
              return DropdownMenuItem<dynamic>(
                value: data,
                child: new Text(
                  data.attributes.first.option +
                      " " +
                      data.attributes.first.name,
                  style: new TextStyle(color: Colors.black),
                ),
              );
            },
          ).toList()
              : null,
        ),
      ),
    );
  }
}