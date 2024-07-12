import 'package:hive/hive.dart';

import '../models/notes_model.dart';

class Boxes {

 static Box<NotesModel> getData () {
   return Hive.box<NotesModel>('notes') ;
 }
}