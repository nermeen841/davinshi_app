// ignore_for_file: avoid_print, non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/home_item.dart';

class StudentProvider extends ChangeNotifier {
  List<StudentClass> students = [];
  int pageIndex = 1;
  bool finish = false;
  void clearList() {
    students.clear();
    pageIndex = 1;
  }

  void setStudentProvider(List list) {
    if (list.isEmpty || list == []) {
      finish = true;
      notifyListeners();
    } else {
      for (var e in list) {
        StudentClass _student = StudentClass(
            id: e['id'],
            name: e['name'],
            email: e['email'],
            phone: e['phone'],
            image: e['img'] == null ? null : e['img_src'] + '/' + e['img'],
            cover: e['cover'] == null ? null : e['img_src'] + '/' + e['cover'],
            facebook: e['facebook'],
            twitter: e['twitter'],
            instagram: e['instagram'],
            linkedin: e['linkedin']);
        students.add(_student);
      }
      pageIndex++;
      notifyListeners();
    }
  }

  Future getStudents() async {
    final String url = domain + 'get-students?page=$pageIndex';
    Response response = await Dio().get(
      url,
      options: Options(headers: {
        'Content-language': prefs.getString('language_code').toString().isEmpty
            ? 'en'
            : prefs.getString('language_code').toString()
      }),
    );
   

    if (response.data['status'] == 1) {
      setStudentProvider(response.data['data']);
    }
    if (response.statusCode != 200) {
      await Future.delayed(const Duration(milliseconds: 700));
      getStudents();
    }
  }
}

class StudentClass {
  int? id;
  String? name;
  String? email;
  String? phone;
  // String? date;
  // String? university;
  // String? major;
  String? facebook;
  String? instagram;
  String? linkedin;
  String? twitter;
  String? image;
  String? cover;
  StudentClass(
      { this.id,
       this.name,
       this.email,
       this.phone,
      //  this.date,
      //  this.university,
      //  this.major,
       this.image,
       this.cover,
       this.facebook,
       this.instagram,
       this.linkedin,
       this.twitter});
}

List<StudentClass> studentHome = [];
List<Ads> studentAds = [];
Future setStudent(Map map) async {
  List list = map['students'];
  List _ads = map['ads'];
  studentHome.clear();
  studentAds.clear();
  for (var e in list) {
    StudentClass _student = StudentClass(
        id: e['id'],
        name: e['name'],
        email: e['email'],
        phone: e['phone'],
       
        image: e['img'] == null ? null : e['img_src'] + '/' + e['img'],
        cover: e['cover'] == null ? null : e['img_src'] + '/' + e['cover'],
        facebook: e['facebook'],
        twitter: e['twitter'],
        instagram: e['instagram'],
        linkedin: e['linkedin']);
    studentHome.add(_student);
  }
  for (var e in _ads) {
    Ads _ad = Ads(
        id: e['id'],
        image: e['src'] + '/' + e['img'],
        link: e['link'],
        position: e['position'],
        type: e['type'] == 'product' ? true : false,
        inApp: checkBool(e['in_app']));
    studentAds.add(_ad);
  }
}

Future getStudentsHome() async {
  final String url = domain + 'home-students';
  try {
    Response response = await Dio().get(url);
    if (response.data['status'] == 1) {
      await setStudent(response.data['data']);
    }
    if (response.statusCode != 200) {
      await Future.delayed(const Duration(milliseconds: 700));
      getStudentsHome();
    }
  } catch (e) {
    print(e);
    await Future.delayed(const Duration(milliseconds: 700));
    getStudentsHome();
  }
}

bool checkPositionStudent(int position) {
  for (var e in studentAds) {
    if (e.position == position) {
      return true;
    }
  }
  return false;
}

Ads PositionStudent(int position) {
  return studentAds.firstWhere((e) => e.position == position);
}
