import 'dart:async';
import 'dart:ui' as ui;

import 'package:dog/src/config/palette.dart';
import 'package:dog/src/dto/location_data_dto.dart';
import 'package:dog/src/util/loading_util.dart';
import 'package:dog/src/util/toast_popup_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class PlaceMap extends StatefulWidget {
  final Function(LocationDataDTO) onLocationUpdated;

  const PlaceMap({
    super.key,
    required this.onLocationUpdated,
  });

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
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        currentPosition = LatLng(position.latitude, position.longitude);
      });
      _getAddressFromLatLng(currentPosition!);
    } catch (e) {
      debugPrint('Method getCurrentLocation: $e');
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

        widget.onLocationUpdated(
          LocationDataDTO(
              latitude: position.latitude,
              longitude: position.longitude,
              address: currentAddress
          )
        );
      });
    } catch (e) {
      debugPrint('Method getAddressFromLatLng: $e');
    }
  }

  Future<void> _initializeMap() async {
    await _loadCustomMarker();
    await _checkLocationPermission();
    await _getCurrentLocation();
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
        ToastPopupUtil.error(context: context, content: '위치 권한 허용이 필요해요.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // 사용자가 권한을 영구적으로 거부한 경우
      ToastPopupUtil.error(context: context, content: '설정을 열어서 위치 권한을 허용해 주세요.');
      return;
    }
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
          initialCameraPosition: CameraPosition(
            target: currentPosition!,
            zoom: 16,
          ),
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
          },
          onCameraMove: (CameraPosition position) {
            setState(() {
              currentPosition = position.target;
            });
          },
          onCameraIdle: () {
            _getAddressFromLatLng(currentPosition!);
          },
          myLocationEnabled: false,
          zoomControlsEnabled: false,
        ),
        Center(
          child: Icon(Icons.place, color: Colors.red, size: 40.w),
        ),
        Positioned(
          bottom: 90,
          right: 16,
          child: FloatingActionButton(
            backgroundColor: Palette.outlinedButton1,
            child: const Icon(Icons.my_location),
            onPressed: () async {
              await _getCurrentLocation();
              if (currentPosition != null) {
                mapController?.animateCamera(
                  CameraUpdate.newLatLng(currentPosition!),
                );
              }
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