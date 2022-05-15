import 'package:path/path.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:sqflite/sqflite.dart';
import 'models/cart.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper.internal();

  factory DbHelper() => _instance;

  DbHelper.internal();

  static Database? _db;

  Future<Database> createDatabase() async {
    if (_db != null) {
      return _db!;
    }
    //define the path to the database
    String path = join(await getDatabasesPath(), '3dcolor.db');
    _db = await openDatabase(path, version: 1, onCreate: (Database db, int v) {
      //create all tables
      db.execute(
        "create table cart(id integer primary key autoincrement,idp integer,idc integer,studentId integer,image varchar(100),svg varchar(100),titleAr varchar(50),titleEn varchar(50),catNameAr varchar(50),catNameEn varchar(50),att varchar(50),product_options varchar(50),des varchar(50),quantity integer,price double, productquantity integer, isOrder integer)",
      );
    });
    return _db!;
  }

  Future<int> createCar(CartProducts shoppingCar) async {
    Database db = await createDatabase();
    return db.insert('cart', shoppingCar.toMap());
  }

  Future<List<CartProducts>> allProducts() async {
    Database db = await createDatabase();
    return CartProducts.listFromMap(await db.query('cart'));
  }

  Future<int> deleteProduct(int id) async {
    Database db = await createDatabase();
    return db.delete('cart', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteProductByIdp(int idp) async {
    Database db = await createDatabase();
    return db.delete('cart', where: 'idp = ?', whereArgs: [idp]);
  }

  Future<int> deleteAll() async {
    Database db = await createDatabase();
    return db.delete('cart');
  }

  Future<int> updateProduct(
      int quantity,
      int idp,
      double price,
      String att,
      String des,
      String productOptions,
      int productquantity,
      int isOrder) async {
    Database db = await createDatabase();
    db.rawUpdate('UPDATE cart SET price = ? WHERE idp = ?', [price, idp]);
    db.rawUpdate('UPDATE cart SET product_options = ? WHERE idp = ?',
        [productOptions, idp]);
    db.rawUpdate('UPDATE cart SET productquantity = ? WHERE idp = ?',
        [productquantity, idp]);
    db.rawUpdate(
        'UPDATE cart SET studentId = ? WHERE idp = ?', [studentId, idp]);
    db.rawUpdate('UPDATE cart SET att = ? WHERE idp = ?', [att, idp]);
    db.rawUpdate('UPDATE cart SET des = ? WHERE idp = ?', [des, idp]);
    db.rawUpdate('UPDATE cart SET isOrder = ? WHERE idp = ?', [isOrder, idp]);

    return db.rawUpdate(
        'UPDATE cart SET quantity = ? WHERE idp = ?', [quantity, idp]);
  }

  Future<List> findProduct(int idp) async {
    Database db = await createDatabase();
    return db.query('cart', where: "idp = ?", whereArgs: [idp], limit: 1);
  }
}
