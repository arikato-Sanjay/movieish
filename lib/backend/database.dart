import 'package:movieish/screens/movieInfo.dart';
import 'package:sqflite/sqflite.dart';

final String tableName = "movieish";
final String movieId = "id";
final String movieName = "movieName";
final String directorName = "directorName";
final String photo = "photo";

class MovieDatabase {
  static Database _database;
  static MovieDatabase _movieDatabase;

  //singleton for database
  MovieDatabase._createInstance();

  factory MovieDatabase() {
    if (_movieDatabase == null)
      _movieDatabase = MovieDatabase._createInstance();
    return _movieDatabase;
  }

  //singleton implementation
  Future<Database> get database async {
    if (_database == null) _database = await initializeDatabase();
    return _database;
  }

  //initializing database
  Future<Database> initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = dir + 'movie.db';

    //opening database
    var database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
            create table $tableName (
            $movieId integer primary key autoincrement,
            $movieName text not null,
            $directorName text not null,
            $photo text not null
            )
          ''');
    });

    return database;
  }

  //performing crud's
  // 1. insert method
  void insertMovie(MovieInfo movieInfo) async {
    var db = await this.database;
    var result = await db.insert(tableName, movieInfo.toMap());
    print('result + $result');
  }

  //fetch operation
  Future<List<MovieInfo>> getMovies() async {
    List<MovieInfo> _movie = [];
    var db = await this.database;
    var result = await db.query(tableName);
    result.forEach((element) {
      var movieInfo = MovieInfo.fromMap(element);
      _movie.add(movieInfo);
    });

    return _movie;
  }

  Future<int> updateMovie(MovieInfo movieInfo, int id) async {
    var db = await this.database;
    return await db.update(tableName, movieInfo.toMap(),
        where: '$movieId = $id');
  }

  Future<int> delete(int id) async {
    var db = await this.database;
    return await db.delete(tableName, where: '$movieId = ?', whereArgs: [id]);
  }
}
