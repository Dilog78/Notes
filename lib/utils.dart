import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/BaseModel.dart';

Directory docsDir;

Future selectDate(
    BuildContext inContext,
    BaseModel inModel,
    String inDateString) async {

  DateTime initDate = DateTime.now();
  if (inDateString != null) {
    List dateParts = inDateString.split(",");
    initDate = DateTime(int.parse(dateParts[0]), int.parse(dateParts[1]),
        int.parse(dateParts[2]));
  }

  DateTime picked = await showDatePicker(
      context: inContext,
      initialDate: initDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100));

  if(picked != null) {
    inModel.setChosenDate(
      DateFormat.yMMMMd('eu').format(picked.toLocal())
    );
    return '${picked.year},${picked.month},${picked.day}';
  }
}
