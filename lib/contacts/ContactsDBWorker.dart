import 'package:sqflite/sqflite.dart';
import 'package:notes/utils.dart' as utils;
import 'package:path/path.dart';
import 'ContactsModel.dart';

class ContactsDBWorker {
  ContactsDBWorker._();

  static final ContactsDBWorker db = ContactsDBWorker._();
  static const query =
      'CREATE TABLE IF NOT EXISTS contacts (id INTEGER PRIMARY KEY, name TEXT, email TEXT, phone TEXT, birthday TEXT)';

  Database _db;

  Future get database async {
    if (_db == null) {
      _db = await init();
    }

    return _db;
  }

  Future<Database> init() async {
    String path = join(utils.docsDir.path, 'contacts.db');
    Database db = await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database inDB, int inVersion) async {
      await inDB.execute(query);
    });
    return db;
  }

  Contact contactFromMap(Map inMap) {
    Contact contact = Contact();
    contact.id = inMap['id'];
    contact.name = inMap['name'];
    contact.phone = inMap['phone'];
    contact.email = inMap['email'];
    contact.birthday = inMap['birthday'];

    return contact;
  }

  Map<String, dynamic> contactToMap(Contact inContact) {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = inContact.id;
    map['name'] = inContact.name;
    map['phone'] = inContact.phone;
    map['email'] = inContact.email;
    map['birthday'] = inContact.birthday;

    return map;
  }

  Future create(Contact inContact) async {
    Database db = await database;

    var val = await db.rawQuery('SELECT MAX(id) + 1 AS id FROM contacts');
    int id = val.first['id'];
    if (id == null) {
      id = 1;
    }

    await db.rawInsert(
        'INSERT INTO contacts (id, name, email, phone, birthday) VALUES (?, ?, ?, ?, ?)',
        [
          id,
          inContact.name,
          inContact.email,
          inContact.phone,
          inContact.birthday
        ]);

    return id;
  }

  Future<Contact> get(int inID) async {
    Database db = await database;

    var rec = await db.query('contacts', where: 'id = ?', whereArgs: [inID]);

    return contactFromMap(rec.first);
  }

  Future<List> getAll() async {
    Database db = await database;

    var recs = await db.query('contacts');
    var list =
        recs.isNotEmpty ? recs.map((m) => contactFromMap(m)).toList() : [];

    return list;
  }

  Future update(Contact inContact) async {
    Database db = await database;

    return await db.update('contacts', contactToMap(inContact),
        where: 'id = ?', whereArgs: [inContact.id]);
  }

  Future delete(int inID) async {
    Database db = await database;

    return await db.delete('contacts', where: 'id = ?', whereArgs: [inID]);
  }
}
