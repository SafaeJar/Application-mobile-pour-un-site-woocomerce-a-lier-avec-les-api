import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce/api_services.dart';
import 'package:woocommerce/models/product.dart';
import 'package:woocommerce/pages/base_page.dart';
import 'package:woocommerce/widgets/widget_product_card.dart';

import '../provider/products_provider.dart';

class ProductPage extends BasePage {
  ProductPage({Key key, this.categoryId}) : super(key: key);

  int categoryId;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends BasePageState<ProductPage> {
  int _page = 1;
  ScrollController _scrollController = new ScrollController();

  final _searchQuery = new TextEditingController();
  Timer _debounce;

  final _sortByOptions = [
    SortBy("popularity", "Popularity", "asc"),
    SortBy("modified", "Latest", "asc"),
    SortBy("price", "Price : High to Low", "desc"),
    SortBy("price", "Price: Low to High", "asc"),
  ];

  @override
  void initState() {
    var productList = Provider.of<ProductProvider>(context, listen: false);
    productList.resetStreams();
    productList.setLoadingState(LoadMoreStatus.INITIAL);
    productList.fetchProducts(_page);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        productList.setLoadingState(LoadMoreStatus.LOADING);
        productList.fetchProducts(++_page);
      }
    });

    _searchQuery.addListener(_onSearchChange);

    super.initState();
  }

  _onSearchChange() {
    var productsList = Provider.of<ProductProvider>(context, listen: false);

    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(seconds: 5), () {
      productsList.resetStreams();
      productsList.setLoadingState(LoadMoreStatus.INITIAL);
     // productsList.fetchProducts(_page, strSearch: _searchQuery.text);
    });
  }

  @override
  Widget pageUI() {
    return _productsList();
  }

  Widget _productsList() {
    return new Consumer<ProductProvider>(
      builder: (context, productsModel, child) {
        if (productsModel.allProducts != null &&
            productsModel.allProducts.length > 0 &&
            productsModel.getLoadMoreStatus() != LoadMoreStatus.INITIAL) {
          return _buildList(productsModel.allProducts,
              productsModel.getLoadMoreStatus() == LoadMoreStatus.LOADING);
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildList(List<Product> items, bool isLoadMore) {
    return Column(
      children: [
        _productFliters(),
        Flexible(
          child: GridView.count(
            shrinkWrap: true,
            controller: _scrollController,
            crossAxisCount: 2,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            children: items.map((Product item) {
              return ProductCard(
                data: item,
              );
            }).toList(),
          ),
        ),
        Visibility(
          child: Container(
            padding: EdgeInsets.all(5),
            height: 35.0,
            width: 35.0,
            child: CircularProgressIndicator(),
          ),
          visible: isLoadMore,
        ),
      ],
    );
  }

  Widget _productFliters() {
    return Container(
      height: 51,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _searchQuery,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide.none,
                ),
                fillColor: Color(0xffe6e6ec),
                filled: true,
              ),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Container(
            decoration: BoxDecoration(
              color: Color(0xffe6e6ec),
              borderRadius: BorderRadius.circular(9.0),
            ),
            child: PopupMenuButton(
              onSelected: (sortBy) {
                var productsList =
                    Provider.of<ProductProvider>(context, listen: false);
                productsList.resetStreams();
                productsList.setSortOrder(sortBy);
                productsList.fetchProducts(_page);
              },
              itemBuilder: (BuildContext context) {
                return _sortByOptions.map((item) {
                  return PopupMenuItem(
                    value: item,
                    child: Container(
                      child: Text(item.text),
                    ),
                  );
                }).toList();
              },
              icon: Icon(Icons.tune),
            ),
          )
        ],
      ),
    );
  }
}
