import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notes/notes/NotesDBWorker.dart';
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
              onPressed: () {
                notesModel.entityBeingEdited = Note();
                notesModel.setColor(null);
                notesModel.setStackIndex(1);
              },
              child: Icon(Icons.add, color: Colors.white),
            ),
            body: ListView.builder(
              itemCount: notesModel.entityList.length,
              itemBuilder: (BuildContext inContext, int inIndex) {
                Note note = notesModel.entityList[inIndex];
                Color color = Colors.white;
                switch (note.color) {
                  case 'green':
                    color = Colors.green;
                    break;
                  case 'blue':
                    color = Colors.blue;
                    break;
                  case 'yellow':
                    color = Colors.yellow;
                    break;
                  case 'grey':
                    color = Colors.grey;
                    break;
                  case 'cyan':
                    color = Colors.cyan;
                    break;
                }
                return Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Slidable(
                    endActionPane: ActionPane(
                      motion: const BehindMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (BuildContext inContext) async {
                            await _deleteNote(inContext, note);
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    child: Card(
                      elevation: 8,
                      color: color,
                      child: ListTile(
                        title: Text('${note.title}'),
                        subtitle: Text('${note.content}'),
                        onTap: () async {
                          notesModel.entityBeingEdited =
                          await NotesDBWorker.db.get(note.id);
                          notesModel
                              .setColor(notesModel.entityBeingEdited.color);
                          notesModel.setStackIndex(1);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future _deleteNote(BuildContext inContext, Note inNote) async {
    return await showDialog(
        context: inContext,
        barrierDismissible: false,
        builder: (BuildContext inAlertContext) {
          return AlertDialog(
              title: Text("Delete Note"),
              content: Text("Are you sure you want to delete ${inNote.title}?"),
              actions: [
                TextButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(inAlertContext).pop();
                    }),
                TextButton(
                    child: Text("Delete"),
                    onPressed: () async {
                      await NotesDBWorker.db.delete(inNote.id);
                      Navigator.of(inAlertContext).pop();
                      ScaffoldMessenger.of(inAlertContext).showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                          content: Text("Note deleted"),
                      ));
                      notesModel.loadData('notes', NotesDBWorker.db);
                    })
              ]);
        });
  }
}
