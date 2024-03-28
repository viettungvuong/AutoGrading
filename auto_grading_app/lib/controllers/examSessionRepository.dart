import 'package:auto_grading_mobile/models/examSession.dart';

class ExamSessionRepository {
  late List<ExamSession> _sessions;

  // private constructor
  ExamSessionRepository._() {
    _sessions = [];
  }

  // singleton
  static final ExamSessionRepository _instance = ExamSessionRepository._();

  static ExamSessionRepository get instance => _instance;

  void addSession(ExamSession session) {
    _sessions.add(session);
  }

  List<ExamSession> getAllSessions() {
    return _sessions;
  }

  void updateLatestSession(ExamSession session){
    _sessions.last=session;
  }

}
