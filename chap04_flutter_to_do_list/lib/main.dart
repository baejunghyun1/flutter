import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
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
  // TodoList 목록
  List<ToDo> toDoList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("할 일"),
      ),
      body: toDoList.isEmpty
          ? Center(
              child: Text("To Do List를 작성해주세요"),
            )
          : ListView.builder(
              itemCount: toDoList.length,
              itemBuilder: (context, index) {
                ToDo toDo = toDoList[index];
                return ListTile(
                  title: Text(
                    toDo.job,
                    style: TextStyle(
                      fontSize: 20,
                      color: toDo.isDone ? Colors.grey : Colors.black,
                      decoration: toDo.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      CupertinoIcons.delete,
                    ),
                    onPressed: () {
                      // 삭제 버튼 클릭시
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('삭제 하시겠습니까?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    '취소',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        toDoList.removeAt(index);
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      '삭제',
                                      style: TextStyle(color: Colors.red),
                                    ))
                              ],
                            );
                          });
                    },
                  ),
                  onTap: () {
                    //아이템 클릭시
                    setState(() {
                      toDo.isDone = !toDo.isDone;
                    });
                  },
                );
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String? job = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CreatePage()),
          );
          if (job != null) {
            setState(() {
              ToDo newToDo = ToDo(job, false);
              toDoList.add(newToDo);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  // TextField의 값을 가져 올 때 사용
  TextEditingController textController = TextEditingController();

  // 경고 메세지
  String? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          'ToDoList 작성',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(CupertinoIcons.chevron_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: textController,
              // 화면이 나왔을 경우 , 입력창에서 커서가 바로 오게 하는 기능
              autofocus: true,
              decoration: InputDecoration(
                hintText: '할 일을 입력하세요',
                errorText: error,
              ),
            ),
          ),

          // Row, Column 등에서 widget 사이에 빈 공간을 넣기 위해 사용
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            //SizedBox : child widget의 size를 강제하기 위해
            child: SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  // 추가하기 버튼을 클릭하면 작동
                  String toDo = textController.text;
                  if (toDo.isEmpty) {
                    setState(() {
                      error = "내용을 입력 해주세요";
                    });
                  } else {
                    setState(() {
                      error = null;
                    });
                  }
                  Navigator.pop(context, toDo);
                },
                child: Text(
                  '추가하기',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// ToDo 클래스
class ToDo {
  String job;
  bool isDone;

  ToDo(this.job, this.isDone);
}
