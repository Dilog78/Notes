import 'package:flutter/material.dart';
import 'package:notes/notes/NotesModel.dart';
import 'package:scoped_model/scoped_model.dart';

class NoteList extends StatelessWidget {
  Widget build(BuildContext inContext) {
    return ScopedModel<NotesModel>(
      model: notesModel,
      child: ScopedModelDescendant<NotesModel>(
        builder: (BuildContext inContext, Widget inChild, NotesModel inModel) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add, color: Colors.white),
              onPressed: () {
                notesModel.entityBeingEdited = Note();
                notesModel.setColor(null);
                notesModel.setStackIndex(1);
              },
            ),
          );
        },
      ),
    );
  }
}