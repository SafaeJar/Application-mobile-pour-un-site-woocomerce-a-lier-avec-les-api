import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/order.dart';
import '../provider/order_provider.dart';
import '../widgets/widget_order_item.dart';

class OrdersPage extends StatefulWidget {

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
 

  @override
  void initState() {
    super.initState();
    var orderProvider = Provider.of<OrderProvider>(context, listen: false);
    orderProvider.fetchOrders();

  
  }

  @override
  Widget build(BuildContext context) {
    return 
  new  Consumer<OrderProvider>(
      builder: (
        context,
         ordersModel,
          child,
          ) {
        if (ordersModel.allOrders != null && ordersModel.allOrders.length > 0) {
          return _listView(context, ordersModel.allOrders);
        }
        // return _listView(context, ordersModel.allOrders);
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    //_listView(context, orders);
  }

  Widget _listView(BuildContext context, List<OrderModel> orders) {
    return ListView(
      children: [
        ListView.builder(
          itemCount: orders.length,
          physics: ScrollPhysics(),
          padding: EdgeInsets.all(8),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: WidgetOrderItem(
                orderModel: orders[index],
              ),
            );
          },
        ),
      ],
    );
  }
}