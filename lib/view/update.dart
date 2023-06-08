import 'package:account_manager/db/dbhandler.dart';
import 'package:account_manager/model/accounts.dart';
import 'package:flutter/material.dart';

///수정, 상세보기 페이지
class UpdatePage extends StatefulWidget {
  ///상세보기의 정보를 받아오는 DTO
  final Accounts acc;
  const UpdatePage({super.key, required this.acc});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
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
  late double width = MediaQuery.of(context).size.width;
  ///기기의 세로 받아오기
  late double height = MediaQuery.of(context).size.height -
      MediaQuery.of(context).padding.top -
      MediaQuery.of(context).padding.bottom;
  ///비밀번호 보이게/안 보이게(보이면 `false`)
  late bool obscure;

  @override
  void initState() {
    super.initState();
    nameCont = TextEditingController();
    nameCont.text = widget.acc.name;
    idCont = TextEditingController();
    idCont.text = widget.acc.id;
    pwCont = TextEditingController();
    pwCont.text = widget.acc.pw;
    urlCont = TextEditingController();
    urlCont.text = widget.acc.url;
    handler = DBHandler();
    handler.initializeDB();
    obscure=true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('계정 정보 수정'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                width: width * 0.7,
                child: TextField(
                  controller: nameCont,
                  decoration: const InputDecoration(
                    labelText: '이름',
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                width: width * 0.7,
                child: TextField(
                  controller: idCont,
                  decoration: const InputDecoration(
                    labelText: 'ID',
                  ),
                ),
              ),
            ),
            SizedBox(
              width: width*0.7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width:width*0.58,
                    child: TextField(
                      controller: pwCont,
                      decoration: const InputDecoration(
                        labelText: '비밀번호',
                      ),
                      obscureText: obscure,
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
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                width: width * 0.7,
                child: TextField(
                  controller: urlCont,
                  decoration: const InputDecoration(
                    labelText: 'URL',
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: ElevatedButton(
                      onPressed: () {
                        updateAcc().whenComplete(() => _showDialog(context));
                      },
                      child: const Text('수정')),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: ElevatedButton(
                      onPressed: () {
                        _showDeleteConfirm(widget.acc.pkey!);
                      },
                      child: const Text('삭제')),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  ///계정 정보 업데이트
  Future<int> updateAcc() async {
    await handler.updateAcc(Accounts(
        name: nameCont.text.trim(),
        id: idCont.text.trim(),
        pw: pwCont.text.trim(),
        url: urlCont.text.trim(),
        pkey: widget.acc.pkey));
    return 0;
  }

  ///수정 완료 다이얼로그 표시
  _showDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          false, //Users must tap the button to make it disappear
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text(
            '수정 결과',
          ),
          content: const Text(
            '수정이 완료되었습니다',
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

  ///삭제 확인 다이얼로그 표시
  _showDeleteConfirm(int pkey) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            '계정 정보 삭제',
          ),
          content: const Text(
            '정말로 삭제하시겠습니까?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                '아니오',
              ),
            ),
            TextButton(
              onPressed: () {
                handler.deleteAcc(pkey);
                Navigator.of(context).pop();
                Navigator.pop(context);
              },
              child: const Text(
                '예',
              ),
            ),
          ],
        );
      },
    );
  }
}
