import 'package:sqflite/sqflite.dart';

class DBHelper {

  static Database? db;
  static Future<void> initDB() async {
    
    if(db != null)
    {
      print("there is a connected database");
    }
    else
    {
      String path =  "${await getDatabasesPath()}todo_app";
      db = await openDatabase(
          path, version: 1,
          onCreate: (Database mydb, int version) async {
          print("database created");
          // When creating the db, create the table
          await mydb.execute(
            "CREATE TABLE Task (taskId INTEGER PRIMARY KEY AUTOINCREMENT,"
            "title STRING,"
            "desc TEXT,"
            "taskDate STRING,"
            //"creationTime STRING,"
            "startTime STRING,"
            "endTime STRING,"
            "isDone INTEGER,"
            "taskReminder String,"
            "userId INTEGER)"
          );
        }
      );
      
    }
  }
}
