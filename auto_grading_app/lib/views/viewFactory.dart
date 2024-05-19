import 'package:auto_grading_mobile/models/Class.dart';
import 'package:auto_grading_mobile/models/Notification.dart';
import 'package:auto_grading_mobile/models/examSession.dart';
import 'package:auto_grading_mobile/views/notificationView.dart';
import 'package:auto_grading_mobile/views/sessionView.dart';
import 'package:auto_grading_mobile/views/studentView.dart';

import '../models/Exam.dart';
import '../models/Student.dart';
import 'View.dart';
import 'classView.dart';
import 'examView.dart';

class ObjectViewFactory{
  static ObjectView? getView(dynamic object){
    if (object is Class) {
      return ClassView(t: object,);
    } else if (object is ExamSession){
      return ExamSessionView(t: object);
    }
    else if (object is Student){
      return StudentView(t: object);
    }
    else if (object is ExamNotification){
      return NotificationView(t: object);
    }
    else{
      return null;
    }
  }
}