import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/tasks/TasksModel.dart';
import 'package:scoped_model/scoped_model.dart';

import 'TasksDBWorker.dart';

class TasksList extends StatelessWidget {
  Widget build(BuildContext inContext) {
    return ScopedModel<TasksModel>(
      model: tasksModel,
      child: ScopedModelDescendant<TasksModel>(
        builder: (BuildContext inContext, Widget inChild, TasksModel inModel) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                tasksModel.entityBeingEdited = Task();
                tasksModel.setChosenDate(null);
                tasksModel.setStackIndex(1);
              },
              child: Icon(Icons.add, color: Colors.white),
            ),
            body: ListView.builder(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              itemCount: tasksModel.entityList.length,
              itemBuilder: (BuildContext inBuildContext, int inIndex) {
                Task task = tasksModel.entityList[inIndex];
                String sDueDate;
                if (task.dueDate != null) {
                  List dateParts = task.dueDate.split(',');
                  DateTime dueDate = DateTime(int.parse(dateParts[0]),
                      int.parse(dateParts[1]), int.parse(dateParts[2]));
                  sDueDate =
                      DateFormat.yMMMMd('de_DE').format(dueDate.toLocal());
                }
                return ListTile(
                  leading: Checkbox(
                    value: task.completed == 'true' ? true : false,
                    onChanged: (inValue) async {
                      task.completed = inValue.toString();
                      await TasksDBWorker.db.update(task);
                      tasksModel.loadData('tasks', TasksDBWorker.db);
                    },
                  ),
                  title: Text('${task.description}',
                      style: task.completed == 'true'
                          ? TextStyle(
                              color: Theme.of(inContext).disabledColor,
                              decoration: TextDecoration.lineThrough)
                          : TextStyle(
                              color: Theme.of(inContext)
                                  .textTheme
                                  .titleMedium
                                  .color)),
                  subtitle: task.dueDate == null
                      ? null
                      : Text(sDueDate,
                          style: task.completed == 'true'
                              ? TextStyle(
                                  color: Theme.of(inContext).disabledColor,
                                  decoration: TextDecoration.lineThrough)
                              : TextStyle(
                                  color: Theme.of(inContext)
                                      .textTheme
                                      .titleMedium
                                      .color)),
                  onTap: () async {
                    if (task.completed == 'true') {
                      await _deleteTask(inContext, task);
                      return;
                    }
                    tasksModel.entityBeingEdited =
                        await TasksDBWorker.db.get(task.id);
                    if (tasksModel.entityBeingEdited.dueDate == null) {
                      tasksModel.setChosenDate(null);
                    } else {
                      tasksModel.setChosenDate(sDueDate);
                    }
                    tasksModel.setStackIndex(1);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future _deleteTask(BuildContext inContext, Task inTask) async {
    return await showDialog(
        context: inContext,
        barrierDismissible: false,
        builder: (BuildContext inAlertContext) {
          return AlertDialog(
              title: Text('Delete Task'),
              content: Text(
                  'Are you sure you want to delete ${inTask.description}?'),
              actions: [
                TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(inAlertContext).pop();
                    }),
                TextButton(
                    child: Text('Delete'),
                    onPressed: () async {
                      await TasksDBWorker.db.delete(inTask.id);
                      Navigator.of(inAlertContext).pop();
                      ScaffoldMessenger.of(inContext).showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                          content: Text('Task deleted')));
                      tasksModel.loadData('tasks', TasksDBWorker.db);
                    })
              ]);
        });
  }
}
