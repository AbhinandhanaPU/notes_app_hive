import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mini_project/model/notes_model.dart';
import 'package:mini_project/utils/color_constant/color_constant.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen(
      {super.key,
      required this.box,
      required this.keylist,
      required this.indexNum});

  final Box<NoteModel> box;
  final List keylist;
  final int indexNum;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            ColorConstant.mycolorListDart[box.get(keylist[indexNum])!.color],
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        color: ColorConstant.mycolorListDart[box.get(keylist[indexNum])!.color],
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                box.get(keylist[indexNum])!.title,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                box.get(keylist[indexNum])!.date,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Text(
                  box.get(keylist[indexNum])!.des,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      height: 1.5, fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
