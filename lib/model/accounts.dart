///계정 정보 DTO
class Accounts{
  ///DB의 Primary Key
  final int? pkey;
  ///사이트 이름
  final String name;
  ///ID
  final String id;
  ///비밀번호
  final String pw;
  ///URL 또는 IP 주소
  final String url;

  Accounts({
    this.pkey,
    required this.name,
    required this.id,
    required this.pw,
    required this.url
  });

  Accounts.fromMap(Map<String, dynamic> res)
  : pkey=res['pkey'],
  name=res['name'],
  id=res['id'],
  pw=res['pw'],
  url=res['url'];
}