import 'package:auto_grading_mobile/api_url.dart';
import 'package:auto_grading_mobile/models/Notification.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

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
  socket.on('connect', (_) {
    print('Connected to server');
    _retrieveBufferedNotifications();
  });

  socket.on('newDocument', (data) {
    print('New document received: $data');
    notifications.add(data.fromMap());
  });
}