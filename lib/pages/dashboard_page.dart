import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:woocommerce/config.dart';
import 'package:woocommerce/widgets/widget_home_categories.dart';
import 'package:woocommerce/widgets/widget_home_products.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            imageCarousel(context),
            WidgetCategories(),
            WidgetHomeProducts(
              labelName: "Top Savers Today!",
              tagId: Config.todayOffersTagId,
            ),
          ],
        ),
      ),
    );
  }

  Widget imageCarousel(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200.0,
      child: Carousel(
          overlayShadow: false,
          borderRadius: true,
          boxFit: BoxFit.none,
          autoplay: true,
          dotSize: 4.0,
          images: [
            FittedBox(
              fit: BoxFit.fill,
              child: Image.network(
                  'https://i.ebayimg.com/images/g/naAAAOSwFiNd1pjd/s-l500.jpg'),
            ),
            FittedBox(
              fit: BoxFit.fill,
              child: Image.network(
                  'https://cdn.carbuzz.com/gallery-images/300x200/43000/800/43844.jpg'),
            ),
            FittedBox(
              fit: BoxFit.fill,
              child: Image.network(
                  'https://i.ytimg.com/vi/xr2xuK4gH-o/mqdefault.jpg'),
            ),
            FittedBox(
              fit: BoxFit.fill,
              child: Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTeDA2bXIVV0IaoSPn_tpTLI8BsHj9vWxaDCw&usqp=CAU'),
            ),
          ]),
    );
  }
}
