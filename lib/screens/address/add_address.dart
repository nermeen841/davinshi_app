// ignore_for_file: prefer_const_constructors_in_immutables, avoid_print

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/provider/address.dart';
import 'package:davinshi_app/provider/map.dart';
import 'package:provider/provider.dart';

import 'address_info.dart';

class AddAddress extends StatefulWidget {
  final bool isUpdate;
  final bool? inCart;
  final AddressClass? address;
  AddAddress(this.isUpdate, {Key? key, this.address, this.inCart})
      : super(key: key);

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  GoogleMapController? _controller;

  void _updatePosition(CameraPosition _position, context) {
    _controller!.animateCamera(CameraUpdate.newCameraPosition(_position));
    Provider.of<MapProvider>(context, listen: false)
        .updateLat(_position.target);
  }

  @override
  Widget build(BuildContext context) {
    MapProvider map = Provider.of<MapProvider>(context, listen: true);
    return Directionality(
      textDirection: getDirection(),
      child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            toolbarHeight: h * 0.11,
            leading: BackButton(
              color: mainColor,
            ),
            elevation: 0,
            title: SizedBox(
              height: h * 0.065,
              child: TextField(
                cursorColor: Colors.black,
                readOnly: map.read,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    map.autoCompleteSearch(value);
                  } else {
                    if (map.predictions.isNotEmpty) {
                      map.clearPlaces();
                    }
                  }
                },
                onSubmitted: (val) async {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                decoration: InputDecoration(
                  focusedBorder: form(),
                  enabledBorder: form(),
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: translate(context, 'inputs', 'search_location'),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  hintStyle: const TextStyle(color: Colors.grey),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
          body: SizedBox(
            height: h,
            width: w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: h * 0.6,
                  width: w,
                  child: Stack(
                    children: [
                      SizedBox(
                        height: h * 0.6,
                        width: w,
                        child: map.latLng == null
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: mainColor,
                                ),
                              )
                            : GoogleMap(
                                onMapCreated: (controller) {
                                  _controller = controller;
                                  map.info();
                                },
                                initialCameraPosition: CameraPosition(
                                    target: map.latLng!, zoom: 18),
                                onCameraIdle: () async {
                                  await map.info();
                                },
                                markers: <Marker>{
                                  Marker(
                                    draggable: true,
                                    markerId: const MarkerId('Marker'),
                                    position: map.latLng!,
                                    icon: map.icon != null
                                        ? map.icon!
                                        : BitmapDescriptor.defaultMarker,
                                  )
                                },
                                onCameraMove: ((_position) =>
                                    _updatePosition(_position, context)),
                              ),
                      ),
                      if (map.predictions.isNotEmpty)
                        Positioned(
                          top: h * 0.02,
                          right: w * 0.1,
                          child: Material(
                            borderRadius: BorderRadius.circular(10),
                            elevation: 5,
                            child: Container(
                              width: w * 0.8,
                              constraints: BoxConstraints(
                                minHeight: h * 0.1,
                                maxHeight: h * 0.55,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: List.generate(
                                        map.predictions.length, (index) {
                                      return ListTile(
                                        leading: const CircleAvatar(
                                          child: Icon(
                                            Icons.pin_drop,
                                            color: Colors.white,
                                          ),
                                        ),
                                        title: Text(map
                                            .predictions[index].description!),
                                        onTap: () async {
                                          var result = await map
                                              .googlePlace.details
                                              .get(map
                                                  .predictions[index].placeId!);
                                          if (result != null &&
                                              result.result != null) {
                                            final lat = result.result!.geometry!
                                                .location!.lat;
                                            final lng = result.result!.geometry!
                                                .location!.lng;
                                            _controller!.moveCamera(
                                                CameraUpdate.newLatLng(
                                                    LatLng(lat!, lng!)));
                                            map.latLng = LatLng(lat, lng);
                                            map.clearPlaces();
                                            map.info();
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                          }
                                        },
                                      );
                                    }),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    width: w,
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: w * 0.05, left: w * 0.05, top: h * 0.03),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            translate(context, 'add_address', 'here'),
                            style: TextStyle(
                                color: Colors.grey, fontSize: w * 0.04),
                          ),
                          Row(
                            children: [
                              Image.asset(
                                'assets/location.png',
                                scale: 2,
                              ),
                              SizedBox(
                                width: w * 0.02,
                              ),
                              if (map.street == null)
                                Text(
                                  translate(context, 'add_address', 'location'),
                                  style: TextStyle(
                                      color: mainColor,
                                      fontSize: w * 0.045,
                                      fontWeight: FontWeight.bold),
                                ),
                              if (map.street != null)
                                Text(
                                  map.street!.length > 35
                                      ? map.street!.substring(0, 35)
                                      : map.street!,
                                  style: TextStyle(
                                      color: mainColor,
                                      fontSize: w * 0.035,
                                      fontWeight: FontWeight.bold),
                                ),
                            ],
                          ),
                          SizedBox(
                            height: h * 0.02,
                          ),
                          InkWell(
                            child: AnimatedOpacity(
                              duration: const Duration(seconds: 2),
                              opacity: map.op,
                              child: Container(
                                height: h * 0.08,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: mainColor,
                                ),
                                child: Center(
                                  child: Text(
                                    translate(context, 'add_address', 'here'),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: w * 0.045,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              if (map.latLng != null) {
                                setLocation(map.latLng!.latitude,
                                    map.latLng!.longitude);
                                print(widget.inCart);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddressInfo(
                                              widget.isUpdate,
                                              address: widget.address,
                                              street: map.street,
                                              country: map.country,
                                              inCart: widget.inCart ?? false,
                                            )));
                              }
                            },
                          ),
                          SizedBox(
                            height: h * 0.02,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  InputBorder form() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: (Colors.grey[200]!), width: 1),
      borderRadius: BorderRadius.circular(20),
    );
  }
}
