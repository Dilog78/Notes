import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notes/contacts/Contacts.dart';
import 'package:notes/notes/Notes.dart';
import 'package:notes/tasks/Tasks.dart';
import 'package:path_provider/path_provider.dart';
import "utils.dart" as utils;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  startMeUp() async {
    Directory docsDir = await getApplicationDocumentsDirectory();
    utils.docsDir = docsDir;
    runApp(NotesBook());
  }
  startMeUp();
}

class NotesBook extends StatelessWidget {
  @override
  Widget build(BuildContext inContext) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Center(child: Text('Notes')),
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.note),
                  text: 'Notes',
                ),
                Tab(
                  icon: Icon(Icons.assignment_turned_in),
                  text: 'Tasks',
                ),
                Tab(
                  icon: Icon(Icons.contacts),
                  text: 'Contacts',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Notes(), Tasks(), Contacts(),
            ],
          ),
        ),
      ),
    );
  }
}




