import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mini_project/model/notes_model.dart';
import 'package:mini_project/utils/color_constant/color_constant.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  var box1 = Hive.box<TodoModel>('todobox');
  List todolist = [];
  @override
  void initState() {
    todolist = box1.keys.toList();
    super.initState();
  }

  TextEditingController taskController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.mainWhite,
      appBar: AppBar(
        backgroundColor: ColorConstant.mainWhite,
        foregroundColor: ColorConstant.colorTheme,
        title: Text(
          "To - do",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView.separated(
          separatorBuilder: (context, index) => SizedBox(height: 20),
          itemCount: todolist.length,
          itemBuilder: (context, index) => InkWell(
            onDoubleTap: () {
              box1.delete(todolist[index]);
              todolist = box1.keys.toList();
              setState(() {});
            },
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: ColorConstant.todoGrey),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      box1.get(todolist[index])!.todotitle,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Checkbox(
                      value: box1.get(todolist[index])!.value,
                      onChanged: (checkboxValue) {
                        box1.put(
                            todolist[index],
                            TodoModel(
                                todotitle: box1.get(todolist[index])!.todotitle,
                                value: checkboxValue));
                        todolist = box1.keys.toList();
                        setState(() {});
                      },
                    )
                  ]),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: ColorConstant.colorTheme,
          onPressed: () {
            TodoBottomSheet(context);
          },
          child: Icon(
            Icons.add,
            size: 30,
          )),
    );
  }

  Future<dynamic> TodoBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(20), bottom: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 15,
              left: 15,
              right: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: taskController,
                decoration: InputDecoration(
                  hintText: "Enter task names",
                  border: InputBorder.none,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () async {
                      if (taskController.text.trim().isNotEmpty) {
                        await box1.add(TodoModel(
                            todotitle: taskController.text, value: false));
                        todolist = box1.keys.toList();
                        setState(() {});
                        Navigator.pop(context);
                        taskController.clear();
                      }
                    },
                    child: Text(
                      "Done",
                      maxLines: 3,
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStatePropertyAll(ColorConstant.colorTheme)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
