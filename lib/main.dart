import 'package:flutter/material.dart';
import 'package:woocommerce/pages/base_page.dart';
import 'package:woocommerce/pages/cart_page.dart';
import 'package:woocommerce/pages/orders_page.dart';
import 'package:woocommerce/pages/paypal_payment.dart';
import 'package:woocommerce/pages/product_details.dart';
import 'package:woocommerce/pages/signup_page.dart';
import 'package:woocommerce/provider/cart_provider.dart';
import 'package:woocommerce/provider/loader_provider.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce/pages/home_page.dart';
import 'package:woocommerce/pages/product_page.dart';
import 'package:woocommerce/provider/order_provider.dart';
import 'package:woocommerce/provider/products_provider.dart';



void main() {
 
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => ProductProvider(),
            child: ProductPage(),
          ),
          ChangeNotifierProvider(
            create: (context) => LoaderProvider(),
            child: BasePage(),
          ),
          ChangeNotifierProvider(
            create: (context) => CartProvider(),
            child: ProductDetails(),
          ),
          ChangeNotifierProvider(
            create: (context) => CartProvider(),
            child: CartPage(),
          ),
          ChangeNotifierProvider(
            create: (context) => OrderProvider(),
            child: OrdersPage(),
          ),
          
        ],
        child: MaterialApp(
          title: "woocommerce",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              fontFamily: 'ProductSans',
              primaryColor: Colors.white,
              brightness: Brightness.light,
              accentColor: Colors.redAccent,
              dividerColor: Colors.redAccent,
              focusColor: Colors.redAccent,
              hintColor: Colors.redAccent,
              textTheme: TextTheme(
                headline4: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.redAccent,
                    height: 1.3),
                headline2: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.redAccent,
                    height: 1.4),
                headline3: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1.3),
                subtitle1: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    height: 1.2),
                caption: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w300,
                    color: Colors.grey,
                    height: 1.2),
              )),
          home: HomePage(),
          routes: <String,WidgetBuilder>{
            '/Paypal': (BuildContext context) => new PaypalpaymentScreen()
          } ,
        ));
  }
}
