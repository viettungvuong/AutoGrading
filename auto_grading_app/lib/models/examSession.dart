import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import 'Class.dart';
import 'Exam.dart';

import 'dart:io';

import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xcel;

class ExamSession{
  late String _name;
  late Map<int,int> _answers; // đáp án đúng
  late int _availableChoices;
  late int _questions;

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

    final xcel.Workbook workbook = xcel.Workbook();
    final xcel.Worksheet sheet = workbook.worksheets[0];


    sheet.getRangeByIndex(1, 1).setText("Name");
    sheet.getRangeByIndex(1, 2).setText("StudentID");
    sheet.getRangeByIndex(1, 3).setText("Score");

    // them du lieu
    for (int i = 0; i < exams.length; i++) {
      final exam = exams[i];
      sheet.getRangeByIndex(i+2, 1).setText(exam.getStudent().getName());
      sheet.getRangeByIndex(i+2, 2).setText(exam.getStudent().getStudentId());
      sheet.getRangeByIndex(i+2, 3).setText(exam.getScore().toString());

    }

    final List<int> bytes = workbook.saveAsStream();
    final documentsDirectory = "/storage/emulated/0/Documents";
    final filePath = '${documentsDirectory}/$_name.xlsx';
    await File(filePath).writeAsBytes(bytes);
    workbook.dispose();
    Fluttertoast.showToast(msg:'Excel file saved at: $filePath');

  }

  bool operator==(Object other) =>
      other is ExamSession && _name == other._name && exams == other.exams;

  int get hashCode => Object.hash(_name,exams);

  double calculateAvg(){
    double total = 0.0;
    int size = 0;

    exams.forEach((exam) {
      total+=exam.getScore();
      size+=1;
    });

    return total/size.toDouble();
  }
}