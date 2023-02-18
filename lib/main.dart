import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notes/notes/Notes.dart';
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
        length: 1,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Notes'),
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.note),
                  text: 'Notes',
                ),
                // Tab(
                //   icon: Icon(Icons.assignment_turned_in),
                //   text: 'Tasks',
                // ),
                // Tab(
                //   icon: Icon(Icons.contacts),
                //   text: 'Contacts',
                // ),
                // Tab(
                //   icon: Icon(Icons.date_range),
                //   text: 'Appointments',
                // ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              // Appointments(), Contacts(), Notes(), Tasks()
              Notes()
            ],
          ),
        ),
      ),
    );
  }
}




