import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MaterialApp(
    home: GoogleMapsScreen(),
  ));
}

class GoogleMapsScreen extends StatefulWidget {
  @override
  State<GoogleMapsScreen> createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {
  GoogleMapController? controller;

  Set<Marker> markers = {};
  LatLng? myLocation;
  getUserLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition();
    this.myLocation = LatLng(position.latitude, position.longitude);
    controller!.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(position.latitude, position.longitude), 20));
  }

  openMapsApp() async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=31.532826649261157,34.45488754659891';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            openMapsApp();
          },
          child: Icon(Icons.gps_fixed),
        ),
        appBar: AppBar(
          title: Text('Google Maps'),
        ),
        body: GoogleMap(
          zoomControlsEnabled: false,
          onTap: (LatLng point) {
            print(point.latitude);
            print(point.longitude);
            this
                .markers
                .add(Marker(markerId: MarkerId('gaza'), position: point));
            setState(() {});
          },
          markers: markers,
          onMapCreated: (GoogleMapController controller) {
            this.controller = controller;
          },
          initialCameraPosition: CameraPosition(
            target: LatLng(31.416665, 34.333332),
            zoom: 11.0,
          ),
        ));
  }
}
