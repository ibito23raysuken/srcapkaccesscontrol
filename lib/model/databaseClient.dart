import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'etudiant.dart';

class databaseClient {
   Database? _database;
  Future<Database?> get database async {
    if (_database != null) {
    } else {
      _database=await create();
    }
    return _database;
  }
//creation de database
  Future create() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String database_directory = join(directory.path, 'database.db');
    var bdd = await openDatabase(database_directory, version: 1, onCreate:_onCreate);
    return bdd;
  }
  Future _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE presence (id INT AUTO_INCREMENT PRIMARY KEY,nom TEXT NOT NULL,ref_qrcode TEXT NOT NULL)''');
  }

  Future<Etudiant?> ajoutItem(Etudiant item) async{
    print(item);
    Database? maDatabase=await database;
    item.id=(await maDatabase?.insert('presence',item.toMap()))!;
    return item;
  }
  //effacer item d'item
  Future<int?> delete(int id,String table) async{
    Database? maDatabase=await database;
    return await maDatabase?.delete(table,where : 'id=?' ,whereArgs:[id]);
  }
  Future<List<Etudiant>> allItem() async{
    List<Etudiant> items=[];
    Database? maDatabase=await database;
    List<Map<String, Object?>>? result =await maDatabase?.rawQuery('SELECT * FROM presence');

    result?.forEach((element) {
      Etudiant etudiant=Etudiant(id: element['id'] as int, nom: element['nom'].toString(), ref_qrcode: element['ref_qrcode'].toString());
      items.add(etudiant);
    });
    return items;
  }
}