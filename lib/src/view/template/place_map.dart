import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class PlaceMap extends StatefulWidget {
  const PlaceMap({super.key});

  @override
  State<PlaceMap> createState() => _PlaceMapState();
}

class _PlaceMapState extends State<PlaceMap> {
  double? lat;
  double? lng;

  bool isLoading = true;

  Uint8List? placeMarkerIcon;

  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    await _loadCustomMarker();
    await _checkLocationPermission();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // 사용자가 권한을 거부한 경우
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are required to use the map.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // 사용자가 권한을 영구적으로 거부한 경우
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permissions are permanently denied, we cannot request permissions.')),
      );
      return;
    }

    // 권한이 허용된 경우
    await _getLocation();
  }

  Future<void> _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
    );
    setState(() {
      lat = position.latitude;
      lng = position.longitude;
    });
  }

  Future<void> _loadCustomMarker() async {
    placeMarkerIcon = await getBytesFromAsset("assets/images/nav_btn_my_walk.png", 100.w.round());
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    ByteData? byteData = await fi.image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Set<Marker> _createMarkers() {
    if (lat == null || lng == null || placeMarkerIcon == null) return {};

    final LatLng currentLatLng = LatLng(lat!, lng!);
    Marker customMarker = Marker(
      markerId: const MarkerId('customMarker'),
      position: currentLatLng,
      icon: BitmapDescriptor.fromBytes(placeMarkerIcon!),
      anchor: const Offset(0.5, 0.5),
    );

    return {customMarker};
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (lat == null || lng == null) {
      return const Center(child: Text('Unable to get location. Please check your settings.'));
    }

    return GoogleMap(
      mapType: MapType.normal,
      liteModeEnabled: false,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      compassEnabled: false,
      trafficEnabled: false,
      buildingsEnabled: /*true*/false,
      indoorViewEnabled: false,
      mapToolbarEnabled: false,
      zoomControlsEnabled: false,
      tiltGesturesEnabled: false,
      scrollGesturesEnabled: false,
      zoomGesturesEnabled: false,
      rotateGesturesEnabled: false,
      initialCameraPosition: CameraPosition(
        target: LatLng(lat!, lng!),
        zoom: 17,
      ),
      markers: _createMarkers(),
      minMaxZoomPreference: const MinMaxZoomPreference(10.0, 18),
      // onMapCreated: (GoogleMapController controller) async {
      //   _controller.complete(controller);
      //   tracking(controller);
      //   setState(() {
      //     polylines={Polyline(
      //       polylineId: const PolylineId('walkRoute'),
      //       color: const Color(0xFF44B46E),
      //       width: 10,
      //       points: walkCoordinates,
      //       jointType: JointType.round,
      //     ),
      //       Polyline(
      //         polylineId: const PolylineId('driveRoute'),
      //         color: const Color(0xFF6549D3),
      //         width: 10,
      //         points: driveCoordinates,
      //         jointType: JointType.round,
      //       )
      //     };
      //   });
      // },
      // polylines: polylines,
    );
  }
}
