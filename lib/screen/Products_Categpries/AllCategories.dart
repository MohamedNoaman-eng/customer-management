import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zain/components/loading/loading.dart';
import 'package:zain/localization/localization_constants.dart';
import 'package:zain/provider/category_provider.dart';
import 'package:zain/widgets/appBar.dart';
import 'category_Details.dart';

class AllCategoriesScreen extends StatefulWidget {
  @override
  _AllCategoriesScreenState createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<CategoryProvider>(context,listen: false).getAllCategories();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var fProvider = Provider.of<CategoryProvider>(context,listen: false);
    var tProvider = Provider.of<CategoryProvider>(context);
    return tProvider.isGet? Scaffold(
      appBar: mainBar("All Categories", context,disPose: (){}),
      body:  Container(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: tProvider.categories.length!=0?GridView.count(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            children: List.generate(tProvider.categories.length, (index) {
              return Card(
                elevation: 5.0,
                child: Column(
                  children: [
                    Expanded(
                      child: InkWell(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Image(
                            image: AssetImage("images/pro.jpg"),
                            fit: BoxFit.fill,
                          ),
                        ),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>CategoryDetailsScreen(
                            fProvider.categories[index]
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
                              child: Text("${tProvider.categories[index].name}",
                                style: TextStyle(fontSize: 13.0),
                              softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              maxLines: 1,),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: Text(
                                    LocalizationConst.translate(context, "Category Code :"),
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
                                      "${tProvider.categories[index].code}",
                                      style: TextStyle(
                                        fontSize: 13.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: Text(
                                    LocalizationConst.translate(context, "Category Kind :"),
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
                                    child: Container(
                                      child: Text(
                                        "${tProvider.categories[index].kind}",
                                        style: TextStyle(
                                          fontSize: 13.0,
                                        ),
                                        maxLines: 1,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
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
            childAspectRatio: 1 /1.2,
          ):Center(child: Text(LocalizationConst.translate(context, "There are no category"))),
        ),
      ),

    ):Loading();
  }
}
