import 'package:auto_grading_mobile/models/examSession.dart';

class ExamSessionRepository {
  late Set<ExamSession> _sessions;

  // private constructor
  ExamSessionRepository._() {
    _sessions = Set();
  }

  // singleton
  static final ExamSessionRepository _instance = ExamSessionRepository._();

  static ExamSessionRepository get instance => _instance;

  void addSession(ExamSession session) {
    _sessions.add(session);
  }

  Set<ExamSession> getAllSessions() {
    return _sessions;
  }

}
