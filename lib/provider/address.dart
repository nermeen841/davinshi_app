// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/user.dart';

class AddressProvider extends ChangeNotifier {
  List<AddressClass> address = [];
  List<String> phones = [];
  int addressId = 0;
  String? addressName;
  AddressClass? addressCart;
  void setAddressModel(AddressClass? _address) {
    addressCart = _address;
  }

  void setAddressId(id, name) {
    addressId = id;
    addressName = name;
  }

  Future getAddress() async {
    print('qweweqweq123123');
    final String url = domain + 'get-myShipping-address';
    try {
      Response response = await Dio().post(
        url,
        options: Options(
          headers: {"auth-token": auth},
        ),
      );
      if (response.data['status'] == 1) {
        List add = response.data['data'];
        address.clear();
        phones.clear();
        add.forEach((e) {
          String? latLng = e['lat_and_long'];
          double lat = 0.0;
          double long = 0.0;
          if (latLng != null) {
            lat = double.parse(latLng.split(',').first);
            long = double.parse(latLng.split(',').last);
          }
          address.add(AddressClass(
              id: e['id'],
              userId: e['user_id'],
              areaId: e['area_id'],
              title: e['title'],
              name: e['name'],
              email: e['email'],
              phone1: e['phone'],
              note: e['note'],
              address: e['address'],
              country: e['address_d'] ?? '',
              lat: lat,
              long: long));
          phones.add(e['phone']);
        });
        if (address.isNotEmpty && addressId == 0) {
          setAddressId(address[0].id, address[0].title);
        } else if (address.isEmpty) {
          setAddressId(0, null);
        }
        setAddressModel(null);
        print('sone');
        print('qweweqweq');
        notifyListeners();
      }
      if (response.statusCode != 200) {
        print("11111111111111111");
        await Future.delayed(const Duration(milliseconds: 700));
        getAddress();
      }
    } catch (e) {
      print(e);
      print("22222222222222");
      await Future.delayed(const Duration(milliseconds: 700));
      getAddress();
    }
  }
}

class AddressClass {
  int id;
  int userId;
  int areaId;
  String title;
  String name;
  String country;
  String? email;
  String phone1;
  String? note;
  String address;
  double lat;
  double long;

  AddressClass(
      {required this.id,
      required this.userId,
      required this.areaId,
      required this.title,
      required this.name,
      required this.email,
      required this.country,
      required this.phone1,
      required this.note,
      required this.address,
      required this.lat,
      required this.long});
}

// AddressClass? address;
// void setAddressModel(AddressClass? _address){
//   address=_address;
// }
double late = 0.0;
double longe = 0.0;
void setLocation(lat, long) {
  late = lat;
  longe = long;
}

int areaId = 1;
