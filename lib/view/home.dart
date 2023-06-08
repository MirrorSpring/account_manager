import 'package:account_manager/db/dbhandler.dart';
import 'package:account_manager/model/accounts.dart';
import 'package:account_manager/view/insert.dart';
import 'package:account_manager/view/update.dart';
import 'package:flutter/material.dart';

///홈 화면
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ///검색어 입력 텍스트필드
  late TextEditingController searchCont;
  late DBHandler handler;
  ///계정 정보를 담아오는 리스트
  late Future<List<Accounts>> acclist;
  ///기기의 가로 받아오기
  late double width = MediaQuery.of(context).size.width;
  ///길이의 세로 받아오기
  late double height = MediaQuery.of(context).size.height -
      MediaQuery.of(context).padding.top -
      MediaQuery.of(context).padding.bottom;

  @override
  void initState() {
    super.initState();
    searchCont = TextEditingController();
    handler = DBHandler();
    handler.initializeDB();
    acclist = handler.accList();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(10),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const InsertPage();
                },
              )).then(
                (value) {
                  setState(() {
                    acclist = handler.accList();
                  });
                },
              );
            },
            child: const Icon(Icons.add),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Icon(
                        Icons.search,
                      ),
                    ),
                    SizedBox(
                      width: width * 0.7,
                      child: TextField(
                        controller: searchCont,
                        decoration: const InputDecoration(
                          hintText: '검색어를 입력하세요',
                        ),
                        onChanged: (value) {
                          if (value.trim().isEmpty) {
                            setState(() {
                              acclist = handler.accList();
                            });
                          } else {
                            setState(() {
                              acclist = handler.searchAcc(value.trim());
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: width,
                height: height*0.85,
                child: FutureBuilder(
                  future: acclist,
                  builder: ((BuildContext context,
                      AsyncSnapshot<List<Accounts>> snapshot) {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ListView.builder(
                          itemCount: snapshot.data?.length, //null safety
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return UpdatePage(
                                        acc: Accounts(
                                            pkey: snapshot.data![index].pkey,
                                            id: snapshot.data![index].id,
                                            pw: snapshot.data![index].pw,
                                            url: snapshot.data![index].url,
                                            name: snapshot.data![index].name));
                                  },
                                )).then(
                                  (value) {
                                    setState(() {
                                      acclist = handler.accList();
                                    });
                                  },
                                );
                                FocusScope.of(context).unfocus();
                              },
                              child: SizedBox(
                                width: width / 10,
                                child: Card(
                                  margin: const EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      Visibility(
                                        visible: false,
                                        child: Text(
                                          "pkey: ${snapshot.data![index].pkey}",
                                          style: const TextStyle(
                                            fontSize: 30,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          snapshot.data![index].name,
                                          style: const TextStyle(
                                            fontSize: 35,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          "ID: ${snapshot.data![index].id}",
                                          style: const TextStyle(
                                            fontSize: 30,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          "URL: ${snapshot.data![index].url}",
                                          style: const TextStyle(
                                            fontSize: 30,
                                          ),
                                          
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return const Center(
                        child: Text(
                          '계정 정보가 없습니다.',
                        ),
                      );
                    }
                  }),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
