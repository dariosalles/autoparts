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
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-23.02960270,-45.56365550),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(-23.02960270,-45.56365550),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
//      floatingActionButton: FloatingActionButton.extended(
//
//        onPressed: (){},
//        label: Text('To the lake!'),
//        icon: Icon(Icons.directions_boat),
//      ),
    );
  }

}