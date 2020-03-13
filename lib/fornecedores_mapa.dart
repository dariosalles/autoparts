import 'package:auto_parts/themes/light_color.dart';
import 'package:flutter/cupertino.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/title_text.dart';
import 'themes/light_color.dart';
import 'themes/theme.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FornecedorMapa extends StatefulWidget {
  @override
  _FornecedorMapaState createState() => _FornecedorMapaState();
}

class _FornecedorMapaState extends State<FornecedorMapa> {


//  initState() {
//
//    inicialMapa();
//  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Mapa Fornecedor'),
        backgroundColor: Color.fromARGB(255, 204, 37, 1),
      ),
      body: Mapa(),
    );
  }
}

class Mapa extends StatefulWidget {
  @override
  State<Mapa> createState() => MapaState();
}

class MapaState extends State<Mapa> {

  double latitude;
  double longitude;

  BitmapDescriptor pinLocationIcon;
  Set<Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();


  @override
  void initState() {
    super.initState();
    inicialMapa();
    setCustomMapPin();
  }

  inicialMapa() async {

    SharedPreferences sp = await SharedPreferences.getInstance();

    setState(() {
      latitude = sp.getDouble('latitude');
      longitude = sp.getDouble('longitude');
    });

  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/img/pin.png');
  }

  @override
  Widget build(BuildContext context) {

    LatLng pinPosition = LatLng(latitude, longitude);
    //LatLng pinPosition = LatLng(-23.02969750,-45.56220480);

    // these are the minimum required values to set
    // the camera position
    CameraPosition initialLocation = CameraPosition(
        zoom: 16,
        bearing: 30,
        target: pinPosition
    );

    return new Scaffold(
      body: GoogleMap(
        myLocationEnabled: true,
        markers: _markers,
        initialCameraPosition: initialLocation,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          setState(() {
            _markers.add(
                Marker(
                    markerId: MarkerId('<MARKER_ID>'),
                    position: pinPosition,
                    icon: pinLocationIcon
                )
            );
          });
        }),
//      GoogleMap(
//
//        mapType: MapType.normal,
//        markers: _markers,
//        initialCameraPosition: _kGooglePlex,
//        onMapCreated: (GoogleMapController controller) {
//          _controller.complete(controller);
//        },
//      ),
//      floatingActionButton: FloatingActionButton.extended(
//
//        onPressed: (){},
//        label: Text('To the lake!'),
//        icon: Icon(Icons.directions_boat),
//      ),
    );
  }

}