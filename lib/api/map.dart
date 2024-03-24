import 'dart:async';

import 'package:estacionamiento_uaem/login/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapEstacionamiento extends StatefulWidget {
  const MapEstacionamiento({super.key});

  @override
  State<MapEstacionamiento> createState() => MapEstacionamientoState();
}

class MapEstacionamientoState extends State<MapEstacionamiento> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(18.980331699560498, -99.23724585717015),
    zoom: 14.4746,
  );

  static const CameraPosition _kestacionamiento = CameraPosition(
      bearing: 18.980331699560498,
      target: LatLng(18.980331699560498, -99.23724585717015),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Maps"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.indigo.shade600,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_sharp),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
              },
            );
          },
        ),
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToEstacionamientoUAEM,
        label: const Text('Ver Estacionamiento'),
        icon: const Icon(Icons.remove_red_eye_outlined),
      ),
    );
  }

  Future<void> _goToEstacionamientoUAEM() async {
    final GoogleMapController controller = await _controller.future;
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(_kestacionamiento));
  }
}
