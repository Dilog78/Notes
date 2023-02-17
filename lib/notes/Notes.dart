import 'package:flutter/cupertino.dart';
import 'package:notes/notes/NotesEntry.dart';
import 'package:notes/notes/NotesModel.dart';
import 'package:scoped_model/scoped_model.dart';

import 'NotesDBWorker.dart';
import 'NotesList.dart';

class Notes extends StatelessWidget {

  Notes() {
    notesModel.loadData('notes', NotesDBWorker.db);
  }

  Widget build(BuildContext inContext) {
    return ScopedModel<NotesModel>(
      model: notesModel,
      child: ScopedModelDescendant<NotesModel>(
        builder: (BuildContext inContext, Widget inChild, NotesModel inModel){
          return IndexedStack(
            index: inModel.stackIndex,
            children: [NoteList(), NotesEntry()],
          );
        },
      ),
    );
  }
}