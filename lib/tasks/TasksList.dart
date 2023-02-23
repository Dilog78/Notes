import 'package:flutter/material.dart';
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
              itemBuilder: (BuildContext inContext, int inIndex) {
                Task task = tasksModel.entityList[inIndex];
                return Dismissible(
                    key: UniqueKey(),
                    background: Container(color: Colors.red,),
                    confirmDismiss: (DismissDirection) async {
                      if (task.completed == 'true') {
                            await _deleteTask(inContext, task);
                            tasksModel.entityList.removeAt(inIndex);
                            return true;
                          } else return false;
                    },
                    child: ListTile(
                      leading: Checkbox(
                        checkColor: Colors.white,
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
                          : Text(task.dueDate,
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
                          return;
                        }
                        tasksModel.entityBeingEdited =
                            await TasksDBWorker.db.get(task.id);
                        if (tasksModel.entityBeingEdited.dueDate == null) {
                          tasksModel.setChosenDate(null);
                        } else {
                          tasksModel.setChosenDate(task.dueDate);
                        }
                        tasksModel.setStackIndex(1);
                      },
                    ));
              },
            ),
          );
        },
      ),
    );
  }

  Future _deleteTask(BuildContext inContext, Task inTask) async {
    await TasksDBWorker.db.delete(inTask.id);
  }
}
