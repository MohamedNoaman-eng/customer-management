import 'package:flutter/material.dart';

import 'package:google_maps/google_maps.dart';
import 'package:zain/screen/cars/maps.dart';

import 'package:zain/widgets/appBar.dart';
import 'dart:ui' as ui;
import 'dart:html';
class ClientLocation extends StatefulWidget {
  double latitude;
  double longitude;
  ClientLocation({this.longitude,this.latitude});
  @override
  _ClientLocationState createState() => _ClientLocationState();
}

class _ClientLocationState extends State<ClientLocation> {
  var per ;
  // Future requestpermission() async{
  //   per = await Geolocator.checkPermission();
  //   if(per == LocationPermission.denied){
  //     await Geolocator.requestPermission().then((value) {
  //       if(value == LocationPermission.always||value ==LocationPermission.whileInUse){
  //         getLatAndLong();
  //       }
  //     });
  //   }else{
  //     getLatAndLong();
  //   }
  // }
  // GoogleMapController gmc;
  // void getLatAndLong(){
  //   Geolocator.getCurrentPosition().then((value) {
  //     gmc.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
  //         target: LatLng(widget.latitude, widget.longitude),
  //         zoom: 16.0
  //     )));
  //     setState(() {
  //       roadMarkers.add( Marker(
  //           markerId: MarkerId("1"),
  //           infoWindow: InfoWindow(title: LocalizationConst.translate(context, "Client Location")),
  //           position: LatLng(widget.latitude, widget.longitude)
  //
  //       ),);
  //     });
  //
  //
  //   });
  // }

  Set<Marker> roadMarkers = {

  };
  @override
  void initState() {
    super.initState();
  }

  // ignore: missing_return
  Widget getMap(){
      String htmlId = '6';
      //ignore: undefined_prefixed_name
       ui.platformViewRegistry.registerViewFactory(htmlId,(int viewId){
        final latlang = LatLng(widget.latitude, widget.longitude);

        final elem = DivElement()
        ..id = htmlId
        ..style.width = "100%"
        ..style.height = "100%"
        ..style.border = "none";
        final mapOptions = MapOptions()
        ..zoom  = 11
        ..tilt =90
        ..center = latlang;
        final map = GMap(elem,mapOptions);
        Marker(
          MarkerOptions()
              ..position = latlang
              ..map = map
              ..title = "Client Location");
        return elem;
       });
       return HtmlElementView(viewType: htmlId);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainBar("Client Location", context,disPose: (){}),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: GoogleMap(),
      )
    );
  }
}
