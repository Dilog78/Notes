import 'package:flutter/material.dart';
import 'package:notes/notes/NotesModel.dart';
import 'package:scoped_model/scoped_model.dart';

import 'NotesDBWorker.dart';

class NotesEntry extends StatelessWidget {
  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _contentEditingController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  NotesEntry() {
    _titleEditingController.addListener(() {
      notesModel.entityBeingEdited.title = _titleEditingController.text;
    });
    _contentEditingController.addListener(() {
      notesModel.entityBeingEdited.content = _contentEditingController.text;
    });
  }

  Widget build(BuildContext inContext) {
    if (notesModel.entityBeingEdited != null) {
      _titleEditingController.text = notesModel.entityBeingEdited.title;
      _contentEditingController.text = notesModel.entityBeingEdited.content;
    }

    return ScopedModel(
        model: notesModel,
        child: ScopedModelDescendant<NotesModel>(builder:
            (BuildContext inContext, Widget inChild, NotesModel inModel) {
          return Scaffold(
              bottomNavigationBar: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  child: Row(children: [
                    TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          FocusScope.of(inContext).requestFocus(FocusNode());
                          inModel.setStackIndex(0);
                        }),
                    Spacer(),
                    TextButton(
                        child: Text('Save'),
                        onPressed: () async {
                          await _save(inContext, notesModel);
                        })
                  ])),
              body: Form(
                  key: _formKey,
                  child: ListView(children: [
                    ListTile(
                        leading: Icon(Icons.title),
                        title: TextFormField(
                            decoration: InputDecoration(hintText: 'Title'),
                            controller: _titleEditingController,
                            validator: (String inValue) {
                              if (inValue.length == 0) {
                                return 'Please enter a title';
                              }
                              return null;
                            })),
                    ListTile(
                        leading: Icon(Icons.content_paste),
                        title: TextFormField(
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 10,
                            decoration: InputDecoration(hintText: 'Content'),
                            controller: _contentEditingController,
                            validator: (String inValue) {
                              if (inValue.length == 0) {
                                _contentEditingController.text = '';
                              }
                              return null;
                            })),
                    ListTile(
                        leading: Icon(Icons.color_lens),
                        title: Row(children: [
                          GestureDetector(
                              child: Container(
                                  decoration: ShapeDecoration(
                                      shape: Border.all(
                                              color: Colors.cyan, width: 18) +
                                          Border.all(
                                              width: 6,
                                              color: notesModel.color == 'cyan'
                                                  ? Colors.cyan
                                                  : Theme.of(inContext)
                                                      .canvasColor))),
                              onTap: () {
                                notesModel.entityBeingEdited.color = 'cyan';
                                notesModel.setColor('cyan');
                              }),
                          Spacer(),
                          GestureDetector(
                              child: Container(
                                  decoration: ShapeDecoration(
                                      shape: Border.all(
                                              color: Colors.green, width: 18) +
                                          Border.all(
                                              width: 6,
                                              color: notesModel.color == 'green'
                                                  ? Colors.green
                                                  : Theme.of(inContext)
                                                      .canvasColor))),
                              onTap: () {
                                notesModel.entityBeingEdited.color = 'green';
                                notesModel.setColor('green');
                              }),
                          Spacer(),
                          GestureDetector(
                              child: Container(
                                  decoration: ShapeDecoration(
                                      shape: Border.all(
                                              color: Colors.blue, width: 18) +
                                          Border.all(
                                              width: 6,
                                              color: notesModel.color == 'blue'
                                                  ? Colors.blue
                                                  : Theme.of(inContext)
                                                      .canvasColor))),
                              onTap: () {
                                notesModel.entityBeingEdited.color = 'blue';
                                notesModel.setColor('blue');
                              }),
                          Spacer(),
                          GestureDetector(
                              child: Container(
                                  decoration: ShapeDecoration(
                                      shape: Border.all(
                                              color: Colors.yellow, width: 18) +
                                          Border.all(
                                              width: 6,
                                              color:
                                                  notesModel.color == 'yellow'
                                                      ? Colors.yellow
                                                      : Theme.of(inContext)
                                                          .canvasColor))),
                              onTap: () {
                                notesModel.entityBeingEdited.color = 'yellow';
                                notesModel.setColor('yellow');
                              }),
                          Spacer(),
                          GestureDetector(
                              child: Container(
                                  decoration: ShapeDecoration(
                                      shape: Border.all(
                                              color: Colors.grey, width: 18) +
                                          Border.all(
                                              width: 6,
                                              color: notesModel.color == 'grey'
                                                  ? Colors.grey
                                                  : Theme.of(inContext)
                                                      .canvasColor))),
                              onTap: () {
                                notesModel.entityBeingEdited.color = 'grey';
                                notesModel.setColor('grey');
                              }),
                          Spacer(),
                        ]))
                  ])));
        }));
  }

  void _save(BuildContext inContext, NotesModel inModel) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    if (inModel.entityBeingEdited.id == null) {
      await NotesDBWorker.db.create(notesModel.entityBeingEdited);
    } else {
      await NotesDBWorker.db.update(notesModel.entityBeingEdited);
    }
    notesModel.loadData('notes', NotesDBWorker.db);
    inModel.setStackIndex(0);
    ScaffoldMessenger.of(inContext).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        content: Text('Note saved')));
  }
}
