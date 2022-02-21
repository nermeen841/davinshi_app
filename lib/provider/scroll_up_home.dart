

import 'package:flutter/cupertino.dart';

class ScrollUpHome extends ChangeNotifier{
  List<bool> scroll = List.generate(4, (index) => false);
  void changeShow(int i,bool val){
    scroll[i] = val;
    notifyListeners();
  }
}

