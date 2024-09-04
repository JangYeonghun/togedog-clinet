import 'dart:async';
import 'dart:ui' as ui;

import 'package:dog/src/config/palette.dart';
import 'package:dog/src/util/loading_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class PlaceMap extends StatefulWidget {
  const PlaceMap({super.key});

  @override
  State<PlaceMap> createState() => _PlaceMapState();
}

class _PlaceMapState extends State<PlaceMap> {
  LatLng? currentPosition;

  bool isLoading = true;

  String currentAddress = '';

  Uint8List? placeMarkerIcon;

  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
    _initializeMap();
    _getCurrentLocation();
  }

  Future<bool> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        currentPosition = LatLng(position.latitude, position.longitude);
        isLoading = false;
      });
      _getAddressFromLatLng(currentPosition!);
      return true;
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
      return false;
    }
  }

  void _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);
      Placemark place = placemarks[0];
      setState(() {
        currentAddress =
        place.street != null
            ? place.street!.contains("대한민국 ")
            ? place.street!.replaceAll("대한민국 ", "")
            : place.street!
            : "주소 없음";
        debugPrint('궯: $currentAddress');
      });
    } catch (e) {
      print(e);
    }
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
    // await _getLocation();
  }

  // Future<void> _getLocation() async {
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high
  //   );
  //   setState(() {
  //     lat = position.latitude;
  //     lng = position.longitude;
  //   });
  // }

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

  // Set<Marker> _createMarkers() {
  //   if (lat == null || lng == null || placeMarkerIcon == null) return {};
  //
  //   final LatLng currentLatLng = LatLng(lat!, lng!);
  //   Marker customMarker = Marker(
  //     markerId: const MarkerId('customMarker'),
  //     position: currentLatLng,
  //     icon: BitmapDescriptor.fromBytes(placeMarkerIcon!),
  //     anchor: const Offset(0.5, 0.5),
  //   );
  //
  //   return {customMarker};
  // }

  Set<Marker> _createMarkers() {
    return {
      Marker(
        markerId: const MarkerId('center_marker'),
        position: currentPosition!,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const LoadingUtil();
    }

    if (currentPosition == null) {
      return const Center(
          child: Text('Unable to get location. Please check your settings.'));
    }

    return Stack(
      children: [
        GoogleMap(
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
          scrollGesturesEnabled: true,
          zoomGesturesEnabled: true,
          rotateGesturesEnabled: true,
          initialCameraPosition: CameraPosition(
            target: currentPosition!,
            zoom: 16,
          ),
          markers: _createMarkers(),
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
          },
          onCameraMove: (CameraPosition position) {
            setState(() {
              currentPosition = position.target;
              _getAddressFromLatLng;
            });
          },
          onCameraIdle: () {
            _getAddressFromLatLng(currentPosition!);
          },
        ),
        Positioned(
          bottom: 90,
          right: 16,
          child: FloatingActionButton(
            child: const Icon(Icons.my_location),
            onPressed: () async {
              double currentZoomLevel = await mapController!.getZoomLevel();

              _getCurrentLocation().then((value) {
                if (value) {
                  CameraPosition cameraPosition = CameraPosition(
                    target: currentPosition!,
                    zoom: currentZoomLevel,
                  );
                  mapController?.animateCamera(
                    CameraUpdate.newCameraPosition(cameraPosition),
                  );
                }
              });
            },
          ),
        ),
        Positioned(
            bottom: 0,
            child: Container(
              width: 1.sw,
              height: 60.h,
              padding: const EdgeInsets.fromLTRB(16, 30, 16, 12),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)
                  ),
                color: Colors.white
              ),
              child: Text(
                currentAddress,
                style: TextStyle(
                  color: Palette.darkFont4,
                  fontSize: 14.sp,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
        ),
      ],
    );
  }
}