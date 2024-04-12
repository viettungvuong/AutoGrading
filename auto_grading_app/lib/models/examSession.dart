import 'Class.dart';
import 'Exam.dart';

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

}