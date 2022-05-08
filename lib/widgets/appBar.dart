import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zain/localization/localization_constants.dart';
import 'package:zain/provider/clientdetailsProvider.dart';

Widget mainBar(title, context, {Function disPose,bool searchIcon=false,bool isClear=false,bool isHome=false}) {
  return AppBar(
    iconTheme: IconThemeData(
      color: Colors.black,
      //color: Color(0xff16071E),
      size: 28,
    ),
    title: Text(
        LocalizationConst.translate(context, title)==null?"temp": LocalizationConst.translate(context, title),
      style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),
    ),
    backgroundColor: Theme.of(context).primaryColor,
    centerTitle: true,
    leading: !isHome?(Navigator.canPop(context)
        ? IconButton(
        icon: Icon(Icons.chevron_left_outlined,color: Colors.white,),
        onPressed: () {
          Navigator.of(context).pop();
          if(isClear){
            Provider.of<ClientDetailsProvider>(context,listen: false).clients = [];
          }
          disPose();
        }
    )
        : null):null,
    actions: [
      searchIcon
          ? IconButton(
          icon: Icon(
            Icons.search,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed("/search");
          })
          : SizedBox(
        width: 0,
      )
    ],
  );
}