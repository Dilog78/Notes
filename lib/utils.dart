import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/BaseModel.dart';
import 'package:intl/date_symbol_data_local.dart';

Directory docsDir;

int parseMonth(String month) {
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  return months.indexOf(month)+1;
}

Future selectDate(BuildContext inContext,
    BaseModel inModel,
    String inDateString) async {
  String locale = Localizations
      .localeOf(inContext)
      .languageCode;
  initializeDateFormatting(locale);

  DateTime initDate = DateTime.now();
  if (inDateString != null) {

    List dateParts = inDateString.split(',');
    int month = parseMonth(dateParts[1]);

    initDate = DateTime(int.parse(dateParts[0]), month,
        int.parse(dateParts[2]));
  }

  DateTime picked = await showDatePicker(
      context: inContext,
      initialDate: initDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100));

  String month = DateFormat.MMMM(locale).format(picked);

  if (picked != null) {
    inModel.setChosenDate(
        '${picked.year},${month},${picked.day}'
    );
    return '${picked.year},${month},${picked.day}';
  }
}
