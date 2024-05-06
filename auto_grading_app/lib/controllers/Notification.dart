import 'package:auto_grading_mobile/api_url.dart';
import 'package:auto_grading_mobile/controllers/examRepository.dart';
import 'package:auto_grading_mobile/models/Notification.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../models/Exam.dart';
import '../models/User.dart';
import 'localPreferences.dart';

IO.Socket socket = IO.io(databaseUrl, <String, dynamic>{
  'transports': ['websocket'],
});

List<ExamNotification> notifications=[];

Future<void> _retrieveBufferedNotifications() async {
  await Preferences.instance.initPreferences();
  final bufferedNotifications = Preferences.instance['bufferedNotifications'] ?? [];
  Preferences.instance['bufferedNotifications']=null;
}

void initializeSocket(){
  if (User.instance.isStudent==false){
    return;
  }
  socket.on('connect', (_) {
    print('Connected to server');
    _retrieveBufferedNotifications();
  });

  socket.on('newDocument', (data) {
    print('New document received: $data');
    if (data["user"]["email"]!=User.instance.email){
      return; // neu khong phai la exam cua nguoi dung nay thi bo qua
    }
    ExamRepository.instance.triggerReinitialize(); // bat buoc phai load lai cac exam
    notifications.add(data.fromMap()); // lay exam tu map
  });
}