import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:woocommerce/api_services.dart';
import 'package:woocommerce/models/product.dart';
import 'package:woocommerce/pages/base_page.dart';
import 'package:woocommerce/widgets/widget_product_details.dart';

import '../models/variable_product.dart';

class ProductDetails extends BasePage {
  ProductDetails({Key key, this.product}) : super(key: key);
  Product product;

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends BasePageState<ProductDetails> {
  APIService apiService;
  @override
  Widget pageUI() {
    return this.widget.product.type == "variable"
        ? _variableProductList()
        : ProductDetailsWidget(data: this.widget.product);
  }

  Widget _variableProductList() {
    apiService = new APIService();
    return new FutureBuilder(
        future: apiService.getVariableProducts(this.widget.product.id),
        builder:
            (BuildContext context, AsyncSnapshot<List<VariableProduct>> model) {
          if (model.hasData) {
            return ProductDetailsWidget(
                data: this.widget.product, variableProducts: model.data);
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
