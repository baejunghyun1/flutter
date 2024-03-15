import 'package:flutter/material.dart';
import 'package:intro_screen_onboarding_flutter/intro_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

// SharedPreferences 인스턴스를 어디서든 접근 가능 하도록 전역 변수로 선언
// late : 나중에 꼭 값을 할당해준다는 의미.
late SharedPreferences prefs;

void main() async {
  // main() 함수 에서 async 를 쓰려면 필요
  WidgetsFlutterBinding.ensureInitialized();

  //Shared_preferences 인스턴스 생성
  prefs = await SharedPreferences.getInstance();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //SharedPrefierences 에서 온보딩 완료 여부 조회
    //isOnboarded 에 해당하는 값에서 null을 반환하는 경우 false를 기본값으로 지정.
    bool isOnboarded = prefs.getBool("isOnboarded") ?? false;

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: "NanumGothic",
        primarySwatch: Colors.blue,
        // backgroundColor: Color.fromARGB(255, 36, 34, 34),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: isOnboarded ? HomePage() : TestScreen(),
    );
  }
}

class TestScreen extends StatelessWidget {
  final List<Introduction> list = [
    Introduction(
      title: '현재의 나',
      titleTextStyle: TextStyle(
          color: Colors.blueGrey,
          fontSize: 35,
          fontFamily: "NanumGothic",
          fontWeight: FontWeight.w800),
      subTitle: '비어있는 박스뿐이지만',
      imageUrl: 'assets/images/빈상자.jpg',
    ),
    Introduction(
      title: '수료 후의 나',
      subTitle: '좋은 내용물이 담길 수 있게 포장지가 깔려서',
      imageUrl: 'assets/images/틀박스.jpg',
    ),
    Introduction(
      title: '10년 후의 나',
      subTitle: '좋은 내용물들이담겨있는보물상자가되어있을것이다',
      imageUrl: 'assets/images/보물상자.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return IntroScreenOnboarding(
      introductionList: list,
      onTapSkipButton: () {
        // 마지막페이지가 나오거나 skip을 해서 homepage로 가기전에 isOnboardrd를 true로 바꿔준다.
        prefs.setBool('isOnboarded', true);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ), //MaterialPageRoute
        );
      },
      // foregroundColor: Colors.red,
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                prefs.clear();
              },
              icon: Icon(Icons.delete))
        ],
      ),
      body: Center(
        child: Text(
          'Welcome to Home Page!',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
