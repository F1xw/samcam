import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';

final String version = "1.1.1";
const String apiUrl = "api.flowei.tech";

class SharedPrefs {
  static SharedPreferences _sharedPrefs;

  factory SharedPrefs() => SharedPrefs._internal();

  SharedPrefs._internal();

  Future<void> init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  String get apiKey => _sharedPrefs.getString("apiKey") ?? "";

  void get setSeenToFalse => _sharedPrefs.setBool("seen", false);
  void get setApiKeyToNone => _sharedPrefs.setString("apiKey", "");
}

String apiKey = SharedPrefs().apiKey;

const AndroidNotificationDetails channelSpecificsAuslauf =
    AndroidNotificationDetails("1", "Auslauferinnerung",
        "Benachrichtigungen zur Erinnerung an den Auslauf von Sammy",
        importance: Importance.max, priority: Priority.high, showWhen: false);

const AndroidNotificationDetails channelSpecificsReinigung =
    AndroidNotificationDetails("2", "Reinigungserinnerung",
        "Benachrichtigungen zur Erinnerung an die Reinigung von Sammys Nagarium",
        importance: Importance.max, priority: Priority.high, showWhen: false);

const AndroidNotificationDetails channelSpecificsFotoGeschpeichert =
    AndroidNotificationDetails("2", "Reinigungserinnerung",
        "Benachrichtigungen zur Erinnerung an die Reinigung von Sammys Nagarium",
        importance: Importance.low, priority: Priority.high, showWhen: true);

void resetApp() {
  SharedPrefs().setApiKeyToNone;
  SharedPrefs().setSeenToFalse;
}

Future payloadHandler(payload) {
  if (payload != null) {
    print('notification payload: $payload');
  }
  var payloadArray = payload.toString().split(" ");

  if (payloadArray[0] == "open-path") {
    return OpenFile.open(payloadArray[1]);
  }

  return null;
}

Future sendNotification(AndroidNotificationDetails channel, String title,
    String body, String payload) async {
  NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: channel);
  return await flutterLocalNotificationsPlugin
      .show(0, title, body, platformChannelSpecifics, payload: payload);
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('icon');
final InitializationSettings initializationSettings = InitializationSettings(
  android: initializationSettingsAndroid,
);

Future<void> initConfig() async {
  await SharedPrefs().init();
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: payloadHandler);
}
