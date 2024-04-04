import 'Exam.dart';

class ExamSession{
  late String _name;
  late Map<int,int> _answers; // đáp án đúng
  late int _availableChoices;

  List<Exam> exams=[];

  ExamSession();

  ExamSession.detailed(this._name, this._availableChoices, this._answers);

  void setName(String name){
    _name=name;
  }

  String getName(){
    return _name;
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

  int getNumOfQuestions(){
    return _answers.length;
  }
}