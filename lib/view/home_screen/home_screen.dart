import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mini_project/controller/notes_controller/notes_controller.dart';
import 'package:mini_project/model/notes_model.dart';
import 'package:mini_project/utils/color_constant/color_constant.dart';
import 'package:mini_project/view/details_screen/details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var box = Hive.box<NoteModel>('notebox');
  List keylist = [];
  @override
  void initState() {
    keylist = box.keys.toList();
    super.initState();
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController editTitleController = TextEditingController();
  TextEditingController editDescController = TextEditingController();
  TextEditingController editDateController = TextEditingController();
  int? selectedIndex;

  Future selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime.now().add(Duration(days: 365)));
    if (picked != null) {
      dateController.text = DateFormat('dd-MM-yyyy').format(picked);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstant.mainWhite,
        foregroundColor: ColorConstant.colorTheme,
        title: Text(
          "My Notes",
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
        actions: [
          Icon(Icons.more_vert),
          SizedBox(
            width: 15,
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: ListView.separated(
          itemCount: keylist.length,
          separatorBuilder: (context, index) => SizedBox(
            height: 15,
          ),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsScreen(
                        box: box, keylist: keylist, indexNum: index),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: ColorConstant
                        .mycolorListDart[box.get(keylist[index])!.color]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      box.get(keylist[index])!.title,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      box.get(keylist[index])!.des,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      box.get(keylist[index])!.date.toString(),
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.share,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                titleController.text =
                                    box.get(keylist[index])!.title;
                                descController.text =
                                    box.get(keylist[index])!.des;
                                dateController.text =
                                    box.get(keylist[index])!.date;
                                EditBottomSheetRefactor(context, index);
                              },
                              child: Icon(
                                Icons.edit,
                              ),
                            ),
                            SizedBox(width: 25),
                            InkWell(
                              onTap: () {
                                NoteScreenController()
                                    .deleteItem(keylist[index]);
                                keylist = box.keys.toList();
                                setState(() {});
                              },
                              child: Icon(
                                Icons.delete,
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorConstant.colorTheme,
        onPressed: () {
          BottomSheetRefactor(context);
        },
        child: Icon(Icons.add, size: 30),
      ),
    );
  }

  Future<dynamic> EditBottomSheetRefactor(BuildContext context, int indexnum) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, insetState) {
        return Container(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 15,
              right: 15,
              top: 15),
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      width: 2,
                      color: ColorConstant.colorTheme,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      width: 2.5,
                      color: ColorConstant.colorTheme,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: descController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Description",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      width: 2,
                      color: ColorConstant.colorTheme,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      width: 2.5,
                      color: ColorConstant.colorTheme,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: dateController,
                onTap: () => {
                  FocusScope.of(context).requestFocus(new FocusNode()),
                  selectDate(),
                },
                decoration: InputDecoration(
                  labelText: "Date",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      width: 2,
                      color: ColorConstant.colorTheme,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      width: 2.5,
                      color: ColorConstant.colorTheme,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Container(
                height: 65,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: InkWell(
                          onTap: () {
                            insetState(() {
                              selectedIndex = index;
                            });
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: ColorConstant.mycolorListDart[index]
                                    .withOpacity(.4),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    width: 4,
                                    color: selectedIndex == index
                                        ? ColorConstant.mycolorListDart[index]
                                        : Colors.transparent)),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(
                          width: 5,
                        ),
                    itemCount: ColorConstant.mycolorListDart.length),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  NoteScreenController().editText(
                      keylist[indexnum],
                      NoteModel(
                          title: titleController.text,
                          des: descController.text,
                          date: dateController.text,
                          color: selectedIndex ?? 0));
                  keylist = box.keys.toList();
                  setState(() {});
                  Navigator.pop(context);
                  titleController.clear();
                  descController.clear();
                  dateController.clear();
                },
                child: Text("Update"),
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStatePropertyAll(ColorConstant.colorTheme),
                    backgroundColor:
                        MaterialStatePropertyAll(ColorConstant.mainWhite)),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        );
      }),
    );
  }

  Future<dynamic> BottomSheetRefactor(BuildContext context) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, insetState) {
        return Container(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 15,
              right: 15,
              top: 15),
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      width: 2,
                      color: ColorConstant.colorTheme,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      width: 2.5,
                      color: ColorConstant.colorTheme,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: descController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Description",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      width: 2,
                      color: ColorConstant.colorTheme,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      width: 2.5,
                      color: ColorConstant.colorTheme,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: dateController,
                onTap: () => {
                  FocusScope.of(context).requestFocus(new FocusNode()),
                  selectDate(),
                },
                decoration: InputDecoration(
                  labelText: "Date",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      width: 2,
                      color: ColorConstant.colorTheme,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      width: 2.5,
                      color: ColorConstant.colorTheme,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Container(
                height: 65,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: InkWell(
                          onTap: () {
                            insetState(() {
                              selectedIndex = index;
                            });
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: ColorConstant.mycolorListDart[index]
                                    .withOpacity(.4),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    width: 4,
                                    color: selectedIndex == index
                                        ? ColorConstant.mycolorListDart[index]
                                        : Colors.transparent)),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(
                          width: 5,
                        ),
                    itemCount: ColorConstant.mycolorListDart.length),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  box.add(NoteModel(
                      title: titleController.text,
                      des: descController.text,
                      date: dateController.text,
                      color: selectedIndex ?? 0));
                  keylist = box.keys.toList();
                  setState(() {});
                  Navigator.pop(context);
                  titleController.clear();
                  descController.clear();
                  dateController.clear();
                },
                child: Text("Done"),
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStatePropertyAll(ColorConstant.colorTheme),
                    backgroundColor:
                        MaterialStatePropertyAll(ColorConstant.mainWhite)),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        );
      }),
    );
  }
}
