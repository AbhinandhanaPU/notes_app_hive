import 'package:hive/hive.dart';
part 'notes_model.g.dart';

@HiveType(typeId: 1)
class NoteModel {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String des;

  @HiveField(2)
  final String date;

  @HiveField(3)
  int color;
  NoteModel(
      {required this.title,
      required this.des,
      required this.date,
      required this.color});
}

@HiveType(typeId: 2)
class TodoModel {
  @HiveField(0)
  final String todotitle;
  @HiveField(1)
  bool? value;

  TodoModel({required this.todotitle, this.value});
}
