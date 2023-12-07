import 'package:hive_flutter/hive_flutter.dart';
import 'package:mini_project/model/notes_model.dart';

class NoteScreenController {
  var box = Hive.box<NoteModel>('notebox');

  editText(var itemKey, NoteModel item) {
    box.put(
        itemKey,
        NoteModel(
          title: item.title,
          des: item.des,
          date: item.date,
          color: item.color,
        ));
  }

  deleteItem(var itemKey) {
    box.delete(itemKey);
  }
}
