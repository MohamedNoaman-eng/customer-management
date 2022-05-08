import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zain/components/loading/loading.dart';
import 'package:zain/localization/localization_constants.dart';
import 'package:zain/models/clientDetails.dart';
import 'package:zain/provider/clientdetailsProvider.dart';
import 'clientDetailsScreen.dart';
import 'package:zain/widgets/appBar.dart';

class ClientScreen extends StatefulWidget {
  @override
  _ClientScreenState createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();

  List<ClientDetails> filteredClients = [];

  filterClients(String id, context) {
    if (id != "") {
      this.setState(() {
        Provider.of<ClientDetailsProvider>(context, listen: false)
                .searchClient =
            Provider.of<ClientDetailsProvider>(context, listen: false)
                .clients
                .where((element) => element.clientId.contains(id))
                .toList();
      });
    } else {
      this.setState(() {
        Provider.of<ClientDetailsProvider>(context, listen: false)
                .searchClient =
            Provider.of<ClientDetailsProvider>(context, listen: false).clients;
      });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ClientDetailsProvider>(context, listen: false).getClients();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var tProvider = Provider.of<ClientDetailsProvider>(context, listen: true);
    var fProvider = Provider.of<ClientDetailsProvider>(context, listen: false);
    return tProvider.isGet
        ? Scaffold(
            appBar: mainBar("Clients", context, disPose: () {}),
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: LayoutBuilder(
                builder: (context, constrains) => Column(
                  children: [
                    Container(
                      height: constrains.maxHeight * .1,
                      child: SimpleAutoCompleteTextField(
                        key: key,
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.all(8.0),
                          hintText: LocalizationConst.translate(
                              context, "Search for client"),
                          suffixIcon: new Icon(Icons.search),
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        controller: TextEditingController(text: ""),
                        suggestions: tProvider.clientIds,
                        textChanged: (text) {
                          filterClients(text, context);
                        },
                        clearOnSubmit: false,
                        onFocusChanged: (value) {
                          return null;
                        },
                        textSubmitted: (text) {
                          setState(() {
                            filterClients(text, context);
                          });
                        },
                      ),
                    ),
                    Container(
                      height: constrains.maxHeight * 0.9,
                      width: double.infinity,
                      child:tProvider.searchClient.length!=0? ListView.separated(
                        itemBuilder: (context, index) => Container(
                          width: MediaQuery.of(context).size.width ,
                          height: 125,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                          ),
                          child: LayoutBuilder(
                            builder:(context,constrains)=> Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Align(
                                  child: Container(
                                    width: constrains.maxWidth,
                                    height: 100,
                                    color: Colors.white,
                                    child: Card(
                                      elevation: 10.0,
                                      child: Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                top: 20.0,
                                                start: 5.0,
                                                end: 5.0,
                                                bottom: 5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              child: Column(
                                                children: [
                                                  Text(
                                                      "${tProvider.searchClient[index].name}",style: TextStyle(fontSize: 13.0),),
                                                  Text(
                                                      "${tProvider.searchClient[index].government}",style: TextStyle(fontSize: 13.0)),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              child: Column(
                                                children: [
                                                  Text(
                                                      "${tProvider.searchClient[index].rate}",style: TextStyle(fontSize: 13.0)),
                                                  Text(
                                                      "${formatDate(tProvider.searchClient[index].createdOn, [
                                                        dd,
                                                        '/',
                                                        mm,
                                                        '/',
                                                        yyyy,
                                                      ])}",style: TextStyle(fontSize: 13.0)),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              child: Column(
                                                children: [
                                                  Text(
                                                      "${tProvider.searchClient[index].email}",style: TextStyle(fontSize: 13.0)),
                                                  Container(
                                                      width: constrains.maxWidth*0.2,
                                                      height: 20,
                                                      child:ListView.builder(
                                                        shrinkWrap: true,
                                                        scrollDirection: Axis.horizontal,
                                                        itemCount: tProvider
                                                            .searchClient[index]
                                                            .phone.length,
                                                        itemBuilder: (context,ind)=>Text("${tProvider
                                                            .searchClient[index]
                                                            .phone[ind]} / ",style: TextStyle(fontSize: 13.0)),
                                                      )
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: constrains.maxWidth*0.2,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ClientDetailsScreen(
                                                                          clientDetails:
                                                                              fProvider.searchClient[index],
                                                                        )));
                                                      },
                                                      child: Text(LocalizationConst
                                                          .translate(context,
                                                              "View Details"),
                                                          style: TextStyle(fontSize: 13.0) ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  alignment: Alignment.bottomCenter,
                                ),
                                CircleAvatar(
                                  child: Text(
                                      tProvider.searchClient[index].clientId),
                                  backgroundColor: Colors.red,
                                  radius: 25.0,
                                )
                              ],
                            ),
                          ),
                        ),
                        itemCount: tProvider.searchClient.length,
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => Container(
                          height: 10.0,
                          width: double.infinity,
                          color: Colors.white,
                        ),
                        physics: BouncingScrollPhysics(),
                      ):Center(child: Text(LocalizationConst.translate(context, "There are no clients"))),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Loading();
  }
}
