import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:zain/components/loading/loading.dart';
import 'package:zain/database_services/leader_services.dart';
import 'package:zain/localization/localization_constants.dart';
import 'package:zain/models/leader.dart';
import 'package:zain/widgets/appBar.dart';

import 'leaderDetails.dart';

class AllLeaderScreen extends StatefulWidget {
  @override
  _AllLeaderScreenState createState() => _AllLeaderScreenState();
}

class _AllLeaderScreenState extends State<AllLeaderScreen> {
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  List<LeaderModel> searchLeaders = [];
  List<String> leadersIds = [];
  filterLeaders(String id, context) {
    if (id != "") {
      this.setState(() {
        searchLeaders =
            leaders.where((element) => element.leaderId.contains(id)).toList();
      });
    } else {
      this.setState(() {
        searchLeaders =
            leaders;
      });
    }
  }

  List<LeaderModel> leaders = [];
  bool isGet = false;

  void getAllLeaders() {
    setState(() {
      isGet = false;
    });
    LeaderService().read().then((value) {
      if (value == null) {
        leaders = [];
      } else {
        leaders = value;
        searchLeaders = value;
        leaders.forEach((element) {
          leadersIds.add(element.leaderId);
        });
      }
      setState(() {
        isGet = true;
      });
    }).catchError((onError) {
      print("error on getting leaders");
    });
  }

  @override
  void initState() {
    getAllLeaders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isGet? Scaffold(
      appBar: mainBar("Leaders", context, disPose: () {}),
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
                        context, "Search for leader"),
                    suffixIcon: new Icon(Icons.search),
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  controller: TextEditingController(text: ""),
                  suggestions: leadersIds,
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
                child: searchLeaders.length!=0?ListView.separated(
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
                                            width: constrains.maxWidth*0.2,
                                            child: Column(
                                              children: [
                                                Text("${searchLeaders[index].leaderName}",style: TextStyle(fontSize: 13.0),),
                                                Text("${searchLeaders[index].profit}",style: TextStyle(fontSize: 13.0),),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: constrains.maxWidth*0.2,
                                            child: Column(
                                              children: [
                                                Text("${searchLeaders[index].orderReward}",style: TextStyle(fontSize: 13.0),),
                                                Text("${formatDate(searchLeaders[index].joiningAt, [dd, '/', mm, '/', yyyy,])}",style: TextStyle(fontSize: 13.0),),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: constrains.maxWidth*0.2,
                                            child: Column(
                                              children: [
                                                Text("${searchLeaders[index].leaderEmail}",style: TextStyle(fontSize: 13.0),),
                                                Text("${searchLeaders[index].leaderPhone}",style: TextStyle(fontSize: 13.0),),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: constrains.maxWidth*0.2,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                TextButton(onPressed: (){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LeaderDetailsScreen(leaderModel: leaders[index],)));
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
                                child: Text(searchLeaders[index].leaderId),
                                backgroundColor: Colors.red,
                                radius: 25.0,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  itemCount: searchLeaders.length,
                  shrinkWrap: true,
                  separatorBuilder: (context,index)=>Container(
                    height: 10.0,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  physics: BouncingScrollPhysics(),
                ):Center(child: Text(LocalizationConst.translate(context, "There are no leaders"))),
              ),
            ],
          ),
        ),
      ),
    ):Loading();
  }
}
