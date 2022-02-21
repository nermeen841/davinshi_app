// ignore_for_file: avoid_print, empty_catches

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:location/location.dart' as lo;
import 'package:davinshi_app/models/constants.dart';

const kGoogleApiKey = "AIzaSyBxCWZSLFx6zvcjHUGC268Mrkw0EREsyb8";

class MapProvider extends ChangeNotifier {
  List<AutocompletePrediction> predictions = [];
  GooglePlace googlePlace = GooglePlace(kGoogleApiKey);
  lo.Location location = lo.Location();
  bool read = true;
  double op = 0.3;
  LatLng? latLng;
  String? country, street;
  BitmapDescriptor? icon;
  Future start() async {
    try {
      BitmapDescriptor.fromAssetImage(
              ImageConfiguration.empty, 'assets/location.png')
          .then((value) {
        icon = value;
        notifyListeners();
      });
      if (latLng == null) {
        bool _serviceEnabled;
        lo.PermissionStatus _permissionGranted;
        lo.LocationData _locationData;
        _serviceEnabled = await location.serviceEnabled();
        if (!_serviceEnabled) {
          _serviceEnabled = await location.requestService();
          if (!_serviceEnabled) {
            // final snackBar = language=='العربية'?SnackBar(
            //   content: Text('يجب منح الاذن للتطبيق بالوصول الى الموقع من الاعدادات'),
            //   action: SnackBarAction(
            //     label: 'تراجع',
            //     disabledTextColor: Colors.yellow,
            //     textColor: Colors.yellow,
            //     onPressed: () {
            //       ScaffoldMessenger.of(context).hideCurrentSnackBar();
            //     },
            //   ),
            // ):
            // SnackBar(
            //     content: Text('Permission must be given to the app to access the location from the settings'),
            //     action: SnackBarAction(
            //       label: 'Undo',
            //       disabledTextColor: Colors.yellow,
            //       textColor: Colors.yellow,
            //       onPressed: () {
            //         ScaffoldMessenger.of(context).hideCurrentSnackBar();
            //       },
            //     ));
            // ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        }
        _permissionGranted = await location.hasPermission();
        if (_permissionGranted == lo.PermissionStatus.denied) {
          _permissionGranted = await location.requestPermission();
          if (_permissionGranted != lo.PermissionStatus.granted) {
            // final snackBar = SnackBar(
            //     content: Text('جاري الحصول عل الموقع'),
            //     action: SnackBarAction(
            //       label: 'Undo',
            //       disabledTextColor: Colors.yellow,
            //       textColor: Colors.yellow,
            //       onPressed: () {
            //         ScaffoldMessenger.of(context).hideCurrentSnackBar();
            //       },
            //     ));
            // ScaffoldMessenger.of(context).showSnackBar(snackBar);
            _locationData = await location.getLocation();
            if (_locationData.longitude != null) {
              latLng =
                  LatLng(_locationData.latitude!, _locationData.longitude!);
              read = false;
              op = 1;
            }
          }
        }
        if (latLng == null) {
          if (_permissionGranted == lo.PermissionStatus.granted ||
              _permissionGranted == lo.PermissionStatus.grantedLimited) {
            // final snackBar = SnackBar(
            //     content: Text('جاري الحصول عل الموقع'),
            //     action: SnackBarAction(
            //       label: 'Undo',
            //       disabledTextColor: Colors.yellow,
            //       textColor: Colors.yellow,
            //       onPressed: () {
            //         ScaffoldMessenger.of(context).hideCurrentSnackBar();
            //       },
            //     ));
            // ScaffoldMessenger.of(context).showSnackBar(snackBar);
            _locationData = await location.getLocation();
            if (_locationData.longitude != null) {
              latLng =
                  LatLng(_locationData.latitude!, _locationData.longitude!);

              read = false;
              op = 1;
            }
          }
        }
      }
      if (latLng == null) {
        // LocationPermission permission;
        // permission = await Geolocator.checkPermission();
        // if (permission == LocationPermission.denied) {
        //   permission = await Geolocator.requestPermission();
        //   if (permission == LocationPermission.denied) {
        //     // final snackBar = language=='العربية'?SnackBar(
        //     //   content: Text('يجب منح الاذن للتطبيق بالوصول الى الموقع من الاعدادات'),
        //     //   action: SnackBarAction(
        //     //     label: 'تراجع',
        //     //     disabledTextColor: Colors.yellow,
        //     //     textColor: Colors.yellow,
        //     //     onPressed: () {
        //     //       ScaffoldMessenger.of(context).hideCurrentSnackBar();
        //     //     },
        //     //   ),
        //     // ):
        //     // SnackBar(
        //     //     content: Text('Permission must be given to the app to access the location from the settings'),
        //     //     action: SnackBarAction(
        //     //       label: 'Undo',
        //     //       disabledTextColor: Colors.yellow,
        //     //       textColor: Colors.yellow,
        //     //       onPressed: () {
        //     //         ScaffoldMessenger.of(context).hideCurrentSnackBar();
        //     //       },
        //     //     ));
        //     // ScaffoldMessenger.of(context).showSnackBar(snackBar);
        //   }
        //   if(permission == LocationPermission.whileInUse || permission == LocationPermission.always){
        //     // final snackBar = SnackBar(
        //     //     content: Text('جاري الحصول عل الموقع'),
        //     //     action: SnackBarAction(
        //     //       label: 'Undo',
        //     //       disabledTextColor: Colors.yellow,
        //     //       textColor: Colors.yellow,
        //     //       onPressed: () {
        //     //         ScaffoldMessenger.of(context).hideCurrentSnackBar();
        //     //       },
        //     //     ));
        //     // ScaffoldMessenger.of(context).showSnackBar(snackBar);
        //     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.lowest);
        //     latLng= LatLng(position.latitude, position.longitude);
        //     read = false;
        //     op=1;
        //   }
        // }
        // if (permission == LocationPermission.deniedForever) {
        //   // final snackBar = language=='العربية'?SnackBar(
        //   //   content: Text('يجب منح الاذن للتطبيق بالوصول الى الموقع من الاعدادات'),
        //   //   action: SnackBarAction(
        //   //     label: 'تراجع',
        //   //     disabledTextColor: Colors.yellow,
        //   //     textColor: Colors.yellow,
        //   //     onPressed: () {
        //   //       ScaffoldMessenger.of(context).hideCurrentSnackBar();
        //   //     },
        //   //   ),
        //   // ):
        //   // SnackBar(
        //   //     content: Text('Permission must be given to the app to access the location from the settings'),
        //   //     action: SnackBarAction(
        //   //       label: 'Undo',
        //   //       disabledTextColor: Colors.yellow,
        //   //       textColor: Colors.yellow,
        //   //       onPressed: () {
        //   //         ScaffoldMessenger.of(context).hideCurrentSnackBar();
        //   //       },
        //   //     ));
        //   // ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // } else {
        //   // final snackBar = SnackBar(
        //   //     content: Text('جاري الحصول عل الموقع'),
        //   //     action: SnackBarAction(
        //   //       label: 'Undo',
        //   //       disabledTextColor: Colors.yellow,
        //   //       textColor: Colors.yellow,
        //   //       onPressed: () {
        //   //         ScaffoldMessenger.of(context).hideCurrentSnackBar();
        //   //       },
        //   //     ));
        //   // ScaffoldMessenger.of(context).showSnackBar(snackBar);
        //   Position position = await Geolocator.getCurrentPosition(
        //       desiredAccuracy: LocationAccuracy.lowest);
        //   latLng = LatLng(position.latitude, position.longitude);
        //   read = false;
        //   op = 1;
        // }
      }
    } catch (e) {
      latLng = const LatLng(29.3057, 48.0308);
      read = false;
      op = 1;
    }
    if (latLng == null) {
      latLng = const LatLng(29.3057, 48.0308);
      read = false;
      op = 1;
    }

    info();
  }

  Future info() async {
    if (Platform.isIOS || Platform.isAndroid) {
      try {
        late String local;
        if (language == 'en') {
          local = 'enUS';
        } else {
          local = 'idID';
        }
        List<Placemark> placemarks = await placemarkFromCoordinates(
            latLng!.latitude, latLng!.longitude,
            localeIdentifier: local);
        Placemark placeMark = placemarks[0];
        String? name = placeMark.name;
        String? subLocality = placeMark.subLocality;
        String? locality = placeMark.locality;
        String administrativeArea = placeMark.administrativeArea ?? '';
        String? postalCode = placeMark.postalCode;
        String country = placeMark.country ?? '';
        String? street = placeMark.street;
        String? subArea = placeMark.subAdministrativeArea;
        String? thoroughfare = placeMark.thoroughfare;
        String? address =
            "1-$name\n2-$subLocality\n3-$locality\n4-$administrativeArea\n5-$postalCode\n6-$country\n7-$street\n8-$subArea\n9-$thoroughfare";
        print(address);
        if (name != '') {
          this.street = name;
        } else if (thoroughfare != '') {
          this.street = thoroughfare;
        } else if (street != '') {
          this.street = street;
        } else {
          this.street = administrativeArea;
        }
        this.country = country + ', ' + administrativeArea;
        // if(subLocality!=''){
        //   this.country = subLocality;
        // }else if(locality!=''){
        //   this.country = locality;
        // }else if(subArea!=''){
        //   this.country = subArea;
        // }else if(administrativeArea!=''){
        //   this.country = administrativeArea;
        // }else{
        //   this.country = country;
        // }
        notifyListeners();
      } catch (e) {}
    }
    notifyListeners();
    // if(Platform.isAndroid){
    //   final coordinates =  Coordinates(latLng!.latitude,latLng!.longitude);
    //   List<Address> addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    //   print(addresses[0].addressLine);//الشارع
    //   print(addresses[0].locality);//الشارع
    //   setState(() {
    //     street = addresses[0].addressLine;
    //     area = addresses[0].locality;
    //   });
    // }
  }

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);

    if (result != null && result.predictions != null) {
      predictions = result.predictions!;
      notifyListeners();
    }
  }

  void updateLat(LatLng _latLng) {
    latLng = _latLng;
    notifyListeners();
  }

  void clearPlaces() {
    predictions = [];
    notifyListeners();
  }
}
