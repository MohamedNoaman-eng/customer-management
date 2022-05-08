import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zain/components/loading/loading.dart';
import 'package:zain/database_services/officer_services.dart';
import 'package:zain/localization/localization_constants.dart';
import 'package:zain/models/officer.dart';
import 'package:zain/provider/officerProvider.dart';
import 'officerDetails.dart';
import 'package:zain/widgets/appBar.dart';

class AllOfficerScreen extends StatefulWidget {
  @override
  _AllOfficerScreenState createState() => _AllOfficerScreenState();
}

class _AllOfficerScreenState extends State<AllOfficerScreen> {
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();


  filterLeaders(String id, context) {
    if (id != "") {
      this.setState(() {
        Provider.of<OfficerProvider>(context,listen: false).searchOfficers =
            Provider.of<OfficerProvider>(context,listen: false). officers.where((element) => element.officerId.contains(id)).toList();
      });
    } else {
      this.setState(() {
        Provider.of<OfficerProvider>(context,listen: false).searchOfficers =
            Provider.of<OfficerProvider>(context,listen: false).officers;
      });
    }
  }





  @override
  void initState() {
   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
     Provider.of<OfficerProvider>(context,listen: false).getAllOfficers();
   });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var fProvider = Provider.of<OfficerProvider>(context,listen: false);
    var tProvider = Provider.of<OfficerProvider>(context);
    return tProvider.isGet? Scaffold(
      appBar: mainBar("Officers", context, disPose: () {}),
      body:  Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: LayoutBuilder(
          builder:(context,constrains)=> Column(
            children: [
              Container(
                height: constrains.maxHeight *.1,
                child: SimpleAutoCompleteTextField(
                  key: key,
                  decoration: new InputDecoration(
                    contentPadding: EdgeInsets.all(8.0),
                    hintText: LocalizationConst.translate(
                        context, "Search for officer"),
                    suffixIcon: new Icon(Icons.search),
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  controller: TextEditingController(text: ""),
                  suggestions: tProvider.officersIds,
                  textChanged: (text) {
                    filterLeaders(text,context);
                  },
                  clearOnSubmit: false,
                  onFocusChanged: (value) {
                    return null;
                  },
                  textSubmitted: (text) {
                    setState(() {
                      filterLeaders(text,context);
                    });
                  },
                ),
              ),
              Container(
                height: constrains.maxHeight *0.9,
                width: double.infinity,
                child: tProvider.searchOfficers.length!=0?ListView.separated(
                  itemBuilder: (context, index) => Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
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
                                  color:  Colors.white,
                                  child: Card(
                                    elevation: 10.0,
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.only(top: 20.0,start: 5.0,end: 5.0,bottom: 5.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            width: constrains.maxWidth *0.2,
                                            child: Column(

                                              children: [
                                                Text("${tProvider.searchOfficers[index].officerName}",style: TextStyle(fontSize: 13.0)),
                                                Text("${tProvider.searchOfficers[index].profit}",style: TextStyle(fontSize: 13.0)),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: constrains.maxWidth *0.2,
                                            child: Column(

                                              children: [
                                                Text("${tProvider.searchOfficers[index].orderReward}",style: TextStyle(fontSize: 13.0)),
                                                Text("${formatDate(tProvider.searchOfficers[index].joiningAt, [dd, '/', mm, '/', yyyy,])}",style: TextStyle(fontSize: 13.0)),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: constrains.maxWidth *0.2,
                                            child: Column(

                                              children: [
                                                Text("${tProvider.searchOfficers[index].officerEmail}",style: TextStyle(fontSize: 13.0)),
                                                Text("${tProvider.searchOfficers[index].officerPhone}",style: TextStyle(fontSize: 13.0)),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: constrains.maxWidth *0.2,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                TextButton(onPressed: (){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>OfficerDetailsScreen(officerModel: fProvider.officers[index],)));
                                                }, child: Text(LocalizationConst.translate(context, "View Details"),style: TextStyle(fontSize: 13.0),)),
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
                                child: Text(tProvider.searchOfficers[index].officerId),
                                backgroundColor: Colors.red,
                                radius: 25.0,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  itemCount: tProvider.searchOfficers.length,
                  shrinkWrap: true,
                  separatorBuilder: (context,index)=>Container(
                    height: 10.0,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  physics: BouncingScrollPhysics(),
                ):Center(child: Text(LocalizationConst.translate(context, "There are no officers"))),
              ),
            ],
          ),
        ),
      ),
    ):Loading();
  }
}
