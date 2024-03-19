import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cat_service.dart';
import 'like_page.dart';

late SharedPreferences prefs;

void main() async {
  // main() 함수 에서 async 를 쓰려면 필요
  WidgetsFlutterBinding.ensureInitialized();

  //Shared_preferences 인스턴스 생성
  prefs = await SharedPreferences.getInstance();

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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          actions: [
            IconButton(
              onPressed: () {
                // 아이콘 버튼 눌렀을 때 동작
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LikePage()),
                );
              },
              icon: Icon(Icons.favorite),
              color: Colors.white,
            )
          ],
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
          children: List.generate(catService.catImages.length, (index) {
            String catImage = catService.catImages[index];
            return GestureDetector(
              child: Stack(
                children: [
                  /**
                   * Positioned
                   * Stack 내에서 자식 위젯의 위치를 정밀하게 제어할 때 사용.
                   * top, right, bottom, left 네가지 속성으로 위치를 조정한다.
                   * Positioned.fill 4가지 속성이 모두 0으로 설정되며,
                   * Stack 모든면을 채우도록 설정이된다.
                   */
                  Positioned.fill(
                    child: Image.network(
                      catImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                      bottom: 8,
                      right: 8,
                      child: Icon(
                        Icons.favorite,
                        color: catService.favoriteCatImages.contains(catImage)
                            ? Colors.indigo
                            : Colors.transparent,
                      ))
                ],
              ),
              onTap: () {
                //사진 클릭시 작동
                catService.toggleFavoriteImage(catImage);
              },
            );
          }),
        ),
      );
    });
  }
}
