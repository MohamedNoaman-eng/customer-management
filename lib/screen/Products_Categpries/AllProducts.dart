import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zain/components/loading/loading.dart';
import 'package:zain/localization/localization_constants.dart';
import 'package:zain/provider/productProvider.dart';
import 'product_Details.dart';
import 'package:zain/widgets/appBar.dart';

class AllProductsScreen extends StatefulWidget {
  @override
  _AllProductsScreenState createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ProductProvider>(context, listen: false).getAllProducts();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var fProvider = Provider.of<ProductProvider>(context, listen: false);
    var tProvider = Provider.of<ProductProvider>(context);
    return tProvider.isGetProducts
        ? Scaffold(
            appBar: mainBar("Products", context,disPose: (){}),
            body: Container(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: tProvider.products.length != 0
                    ? GridView.count(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        children:
                            List.generate(tProvider.products.length, (index) {
                          return Card(
                            elevation: 5.0,
                            child: Column(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      child: Image(
                                        image: AssetImage("images/pro.jpg"),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductDetailsScreen(
                                                    productModel: fProvider
                                                        .products[index],
                                                  )));
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text(
                                            "${tProvider.products[index].name}",
                                            style: TextStyle(
                                                fontSize: 13.0),
                                            maxLines: 1,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),

                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 5.0),
                                              child: Text(
                                                LocalizationConst.translate(
                                                    context, "Product Code :"),
                                                style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 5.0),
                                                child: Text(
                                                  "${tProvider.products[index].productId}",
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 5.0),
                                              child: Text(
                                                "${LocalizationConst.translate(
                                                    context, "Price")}:",
                                                style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 5.0),
                                                child: Text(
                                                  "${tProvider.products[index].price}",
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        mainAxisSpacing: 3.0,
                        crossAxisSpacing: 5,
                        childAspectRatio: 1 / 1.2,
                      )
                    : Center(
                        child: Text(LocalizationConst.translate(
                            context, "There are no products"))),
              ),
            ),
          )
        : Loading();
  }
}
