// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:kocart/models/productsCla.dart';
//
// class ProductsPro extends ChangeNotifier{
//   List<ProductCla> _items = List.generate(9*4, (index) => ProductCla(
//       index, (index%9), 'Title'+(index+1).toString(), 'Description'+(index+1).toString(), 'Material'+((index%5)+1).toString(), (index+1)*1000.0,
//       (index+1)*100.0, index%3==0?true:false,'assets/food${((index%4)+1).toString()}.png',index!=35?'assets/food${((index%4)+1).toString()}.png':'assets/food1.png')
//   );
//   List<Offer> _offers = List.generate(4, (index) => Offer(index, 'assets/food'+(index+1).toString()+'.png'));
//   List<Categories> _category = List.generate(4, (index) => Categories(index, Icons.king_bed, 'Category'+(index+1).toString()));
//   List filterList = [];
//
//   String? search;
//   String sortName='Recently';
//
//   List<ProductCla> get items{
//     if(search==null||search==''){
//       return [..._items];
//     }
//     List<ProductCla> search2=[];
//     _items.forEach((element) {
//       if(element.title.toLowerCase().contains(search!)||element.title.toUpperCase().contains(search!)){
//         search2.add(element);
//       }
//     });
//     return search2;
//   }
//   List<Offer> get offer{
//     return [..._offers];
//   }
//   List<Categories> get cat{
//     return [..._category];
//   }
//   List<ProductCla> catItems (idCategory){
//     return _items.where((element) => element.idCategory==idCategory).toList();
//   }
//   catId (idCategory){
//     return _category.firstWhere((element) => element.id==idCategory);
//   }
//   proLength(){
//     List length =[];
//     cat.forEach((element) {
//       List cat = _items.where((element2) => element2.idCategory==element.id).toList();
//       length.add(cat.length);
//     });
//     return length;
//   }
//   void startSearch (val){
//     search=val;
//     notifyListeners();
//   }
//   void sort(val){
//     search='';
//     sortName=val;
//     notifyListeners();
//   }
// }