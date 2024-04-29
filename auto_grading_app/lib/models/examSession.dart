import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';

import 'Class.dart';
import 'Exam.dart';

import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ExamSession{
  late String _name;
  late Map<int,int> _answers; // đáp án đúng
  late int _availableChoices;
  late int _questions;
  String? id; // id tren database

  late Class _class;

  List<Exam> exams=[];

  ExamSession();

  ExamSession.detailed(this._name, this._availableChoices, this._answers);

  ExamSession.examsOnly(this.exams);

  void setName(String name){
    _name=name;
  }

  String getName(){
    return _name;
  }

  void setClass(Class sClass){
    _class=sClass;
  }

  Class getClass(){
    return _class;
  }

  void setAnswers(Map<int,int> answers){
    _answers=answers;
  }

  Map<int,int> getAnswers(){
    return _answers;
  }

  void setAvailableChoices(int availableChoices){
    _availableChoices=availableChoices;
  }

  int getAvailableChoices(){
    return _availableChoices;
  }

  void setNumOfQuestions(int questions){
    _questions=questions;
  }

  int getNumOfQuestions(){
    return _questions;
  }


  void generateExcelFile() async {
    // Create Excel file
    final excel = Excel.createExcel();
    Sheet sheetObject = excel['GradeSheet'];

    // Add column names
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0)).value = 'Name' as CellValue;
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0)).value = 'Student ID' as CellValue;
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0)).value = 'Score' as CellValue;

    // Add exam data
    for (int i = 0; i < exams.length; i++) {
      final exam = exams[i];
      sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i + 1)).value = exam.getStudent().getName() as CellValue;
      sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i + 1)).value = exam.getStudent().getStudentId() as CellValue;
      sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: i + 1)).value = exam.getScore() as CellValue;
    }

    // Allow the user to pick where to save the file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      dialogTitle: 'Save Excel File As',
    );

    if (result != null) {
      // Save Excel file to selected location
      File file = File(result.files.single.path!);
      file.writeAsBytesSync(excel.encode()!);

      print('Excel file saved at: ${file.path}');
    } else {
      // User canceled file picking
      print('No file selected');
    }
  }

  bool operator==(Object other) =>
      other is ExamSession && _name == other._name && exams == other.exams;

  int get hashCode => Object.hash(_name,exams);
}