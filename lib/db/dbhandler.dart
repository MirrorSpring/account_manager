import 'package:account_manager/model/accounts.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

///데이터베이스에 접근하는 클래스(DAO)
class DBHandler{

  ///SQLite DB를 생성하는 메소드(처음 한 번만 실행)
  Future<Database> initializeDB() async{
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'accounts.db'),
      onCreate: (db, version) async {
        await db.execute(
            'create table accounts(pkey integer primary key autoincrement, name text, id text, pw text, url text)');
      },
      version: 1,
    );
  }

  ///계정 정보 리스트
  Future<List<Accounts>> accList() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery('select * from accounts order by name');
    return queryResult.map((e) => Accounts.fromMap(e)).toList();
  }

  ///계정 정보 입력
  Future<int> insertAcc(Accounts account) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawInsert(
        'insert into accounts (name,id,pw,url) values (?,?,?,?)',
        [account.name, account.id, account.pw, account.url]);

    return result;
  }

  ///계정 정보 검색(이름으로 검색)
  Future<List<Accounts>> searchAcc(String query) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery('select * from accounts where name like ?', ["%$query%"]);

    return queryResult.map((e) => Accounts.fromMap(e)).toList();
  }

  ///계정 정보 수정
  Future<int> updateAcc(Accounts account) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawInsert(
        'update accounts set name=?,id=?,pw=?,url=? where pkey=?',
        [account.name, account.id, account.pw, account.url, account.pkey]);
    return result;
  }

  ///계정 정보 삭제
  Future<int> deleteAcc(int pkey) async{
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawInsert(
        'delete from accounts where pkey=?',
        [pkey]);
    return result;
  }
}