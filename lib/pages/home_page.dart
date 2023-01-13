import 'package:flutter/material.dart';
import 'package:woocommerce/models/payment_method.dart';
import 'package:woocommerce/pages/cart_page.dart';
import 'package:woocommerce/pages/dashboard_page.dart';
import 'package:woocommerce/pages/order_detail.dart';
import 'package:woocommerce/pages/payment_screen.dart';
import 'package:woocommerce/widgets/unauth_widget.dart';
import 'package:woocommerce/widgets/widget_order_item.dart';
import 'package:woocommerce/widgets/widget_payment_method_list_item.dart';

import 'login_Page.dart';
import 'orders_page.dart';
import 'my_account.dart';


class HomePage extends StatefulWidget {
    int selectedPage;
  HomePage({Key key, this.selectedPage}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _widgetList = [
    DashboardPage(),
    UnAuthWidget(),
    DashboardPage(),
    OrderDetailsPage(),
   // MyAccount(),
  ];
  List<String> _titleList=[
    "Woocommerce app",
    "My cart",
    "My Favourites",
    "My account",
  ];
  int _index = 0;

  @override
  void initState() {
    super.initState();

    if (this.widget.selectedPage != null) {
      _index = this.widget.selectedPage;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Store',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'My Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favourites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'My Account',
          ),
        ],
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.shifting,
        currentIndex: _index,
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
      ),
      body: _widgetList[_index],
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      brightness: Brightness.dark,
      elevation: 0,
      backgroundColor: Colors.redAccent,
      automaticallyImplyLeading: true,
      title: Text(
        "Grocery App",
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        Icon(
          Icons.notifications_none,
          color: Colors.white,
        ),
        SizedBox(
          width: 10,
        ),
        Icon(
          Icons.shopping_cart,
          color: Colors.white,
        ),
        SizedBox(
          width: 10,
        ),
      ],
    );
  }
}
