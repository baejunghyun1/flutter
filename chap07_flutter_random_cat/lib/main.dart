import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CatService()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class CatService extends ChangeNotifier {
  List<String> catImage = [];
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CatService>(builder: (context, catService, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            '랜덤고양이',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.indigo,
        ),
        // GridView count 생성자로, 그리드 내 아이템 수를
        // 기반으로 레이아웃을 구성할 수 있다.
        body: GridView.count(
          // 크로스 축으로 아이템이 2개씩 배치되도록 설정
          crossAxisCount: 2,
          // 그리드의 주축(세로) 사이의 아이템 공간 설정
          mainAxisSpacing: 8,
          // 그리드의 크로스축(가로) 사이의 아이템 공간 설정
          crossAxisSpacing: 8,
          // 그리드 전체에 대한 패딩 설정
          padding: EdgeInsets.all(8),
          // 그리드에 표시될 위젯의 리스트, 10개의 위젯을 생성
          children: List.generate(10, (index) {
            return Center(
                child: Text(
              "$index",
              style: TextStyle(
                fontSize: 25,
              ),
            ));
          }),
        ),
      );
    });
  }
}
