import 'package:account_manager/db/dbhandler.dart';
import 'package:account_manager/model/accounts.dart';
import 'package:flutter/material.dart';

///입력 페이지
class InsertPage extends StatefulWidget {
  const InsertPage({super.key});

  @override
  State<InsertPage> createState() => _InsertPageState();
}

class _InsertPageState extends State<InsertPage> {
  ///이름 텍스트필드
  late TextEditingController nameCont;
  ///ID 텍스트필드
  late TextEditingController idCont;
  ///비밀번호 텍스트필드
  late TextEditingController pwCont;
  ///URL 텍스트필드
  late TextEditingController urlCont;
  late DBHandler handler;
  ///기기의 가로 받아오기
  late double width=MediaQuery.of(context).size.width;
  ///기기의 세로 받아오기
  late double height=MediaQuery.of(context).size.height-MediaQuery.of(context).padding.top-MediaQuery.of(context).padding.bottom;
  late bool obscure;

  @override
  void initState() {
    super.initState();
    nameCont = TextEditingController();
    idCont = TextEditingController();
    pwCont = TextEditingController();
    urlCont = TextEditingController();
    handler = DBHandler();
    handler.initializeDB();
    obscure=true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('계정 정보 입력'),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: SizedBox(
                      width: width*0.7,
                      child: TextField(
                        controller: nameCont,
                        decoration: const InputDecoration(
                          labelText: '이름',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: SizedBox(
                      width: width*0.7,
                      child: TextField(
                        controller: idCont,
                        decoration: const InputDecoration(
                          labelText: 'ID',
                        ),
                      ),
                    ),
                  ),
                  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: SizedBox(
                      width: width * 0.6,
                      child: TextField(
                        controller: pwCont,
                        decoration: const InputDecoration(
                          labelText: '비밀번호',
                        ),
                        obscureText: obscure,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (obscure) {
                        setState(() {
                          obscure = false;
                        });
                      } else {
                        setState(() {
                          obscure = true;
                        });
                      }
                    },
                    icon: SizedBox(
                      width: width * 0.1,
                      child: Icon(
                        obscure ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                ],
              ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: SizedBox(
                      width: width*0.7,
                      child: TextField(
                        controller: urlCont,
                        decoration: const InputDecoration(
                          labelText: 'URL',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height/10,
                  ),
                  ElevatedButton(onPressed: () {
                    addAcc().whenComplete(() => _showDialog(context));
                  }, child: const Text('입력'))
                ],
              ),
            ),
          )),
    );
  }

  ///계정 정보 입력
  Future<int> addAcc() async {
    Accounts acc = Accounts(
        name: nameCont.text.trim(),
        id: idCont.text.trim(),
        pw: pwCont.text.trim(),
        url: urlCont.text.trim());
    await handler.insertAcc(acc);
    return 0;
  }

  ///입력 완료 다이얼로그 표시
  _showDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          false, //Users must tap the button to make it disappear
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text(
            '입력 결과',
          ),
          content: const Text(
            '입력이 완료되었습니다',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.pop(context);
              },
              child: const Text(
                '확인',
              ),
            ),
          ],
        );
      },
    );
  }
}
