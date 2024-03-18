import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'create_page.dart';
import 'main.dart';

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
