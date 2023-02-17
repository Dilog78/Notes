import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

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
            children: [NoteList(), NotesEntity()],
          );
        },
      ),
    )
  }
}