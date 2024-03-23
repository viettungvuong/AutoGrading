class ExamInformation{
  late String _name;
  late Map<int,int> _answers;

  ExamInformation();

  ExamInformation.detailed(this._name, this._answers);

  void setName(String name){
    _name=name;
  }

  void setAnswers(Map<int,int> answers){
    _answers=answers;
  }

  Map<int,int> getAnswers(){
    return _answers;
  }
}