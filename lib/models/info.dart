// ignore_for_file: avoid_function_literals_in_foreach_calls

class Info {
  int id;
  String name;
  String desAr;
  String desEn;
  Info(
      {required this.id,
      required this.name,
      required this.desAr,
      required this.desEn});
}

List<Info> info = [];

void setInfo(List list) {
  info.clear();
  list.forEach((e) {
    info.add(Info(
        id: e['id'],
        name: e['name'],
        desAr: e['description_ar'],
        desEn: e['description_en']));
  });
}
