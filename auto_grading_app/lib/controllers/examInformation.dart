class ExamInformation{
  Map<int,int> _answers={};
  

  void setAnswers(List<int> answer){
    for (int i=0; i<answer.length; i++){
      _answers[i]=answer[i];
    }
  }

  Map<int,int> getAnswers(){
    return this._answers;
  }
}