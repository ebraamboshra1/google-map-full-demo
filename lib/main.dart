import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Google map demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  late String _mapStyle;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(30.075808, 31.281116),
    zoom: 11,
  );

  final GoogleMapPolyline googleMapPolyline =
      GoogleMapPolyline(apiKey: "YOUR KEY HERE");
  final List<Polyline> polyline = [];
  List<LatLng> routeCoords = [];

  computePath() async {
    LatLng origin = const LatLng(30.075808, 31.281116);
    LatLng end = const LatLng(30.005493, 31.477898);
    routeCoords.addAll((await googleMapPolyline.getCoordinatesWithLocation(
        origin: origin, destination: end, mode: RouteMode.driving))!);
    setState(() {
      polyline.add(
        Polyline(
            polylineId: const PolylineId('iter'),
            visible: true,
            points: routeCoords,
            width: 4,
            color: Colors.blue,
            startCap: Cap.roundCap,
            endCap: Cap.buttCap),
      );
    });
  }

  @override
  void initState() {
    computePath();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: GoogleMap(
          mapType: MapType.normal,
          polylines: Set.from(polyline),
          initialCameraPosition: _kGooglePlex,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: false,
          onCameraIdle: () {},
          onCameraMove: (v) {},
          onMapCreated: (GoogleMapController controller) async {
            _controller.complete(controller);
            (await _controller.future).setMapStyle(_mapStyle);
          },
        ),
      ),
    );
  }
}
