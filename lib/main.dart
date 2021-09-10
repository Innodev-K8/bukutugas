import 'package:bukutugas/models/assignment.dart';
import 'package:bukutugas/providers/ad/interstitial/done_assignment_ad_provider.dart';
import 'package:bukutugas/providers/assignment/subject_assignments_provider.dart';
import 'package:bukutugas/providers/auth/auth_controller.dart';
import 'package:bukutugas/providers/firebase_providers.dart';
import 'package:bukutugas/providers/shared_preference_provider.dart';
import 'package:bukutugas/repositories/all_assignment_repository.dart';
import 'package:bukutugas/repositories/custom_exception.dart';
import 'package:bukutugas/screens/screens.dart';

import 'package:bukutugas/styles.dart';
import 'package:bukutugas/utils/CustomAgoMessage.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MobileAds.instance.initialize();
  await initializeDateFormatting("id_ID", null);

  timeago.setLocaleMessages('id', CustomAgoMessage());
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation("Asia/Jakarta"));

  RemoteConfig remoteConfig = RemoteConfig.instance;

  remoteConfig.setDefaults(<String, dynamic>{
    'show_ad': false,
  });

  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);

    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: Duration(seconds: 10),
      minimumFetchInterval: Duration(minutes: 1),
    ));
  } else {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }

  await remoteConfig.fetchAndActivate();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferenceProvider
            .overrideWithValue(await SharedPreferences.getInstance()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buku Tugas',
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => AppWrapper(),
        '/auth/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/subject': (context) => SubjectScreen(),
        '/assignment/detail': (context) => DetailAssignmentScreen(),
        '/assignment/create': (context) => CreateAssignmentScreen(),
      },
      navigatorObservers: [
        FirebaseAnalyticsObserver(
          analytics: context.read(firebaseAnalyticsProvider),
        ),
      ],
    );
  }
}

class AppWrapper extends HookWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final InitializationSettings initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('app_icon'),
  );

  @override
  Widget build(BuildContext context) {
    final auth = useProvider(authProvider);

    // preload interstitial ads
    useEffect(() {
      context.read(doneAssignmentAdProvider);
    });

    return FutureBuilder(
        future: flutterLocalNotificationsPlugin.initialize(
          initializationSettings,
          onSelectNotification: (payload) async {
            debugPrint("Notification Payload:");
            debugPrint(payload);

            final String? assignmentId = payload?.split('|')[0];
            final String? userId = auth.data?.value?.uid;

            debugPrint('got userid and assignment id');
            debugPrint(assignmentId);
            debugPrint(userId);

            if (assignmentId == null || userId == null) return;

            debugPrint('trying to find assignment');

            final Assignment? assignment = await context
                .read(assignmentRepositoryProvider)
                .findAssignmentById(
                  userId: userId,
                  assignmentId: assignmentId,
                );

            if (assignment == null) return;

            debugPrint('got assignment');
            debugPrint(assignment.title);

            context.read(selectedAssignmentProvider).state = assignment;

            Navigator.of(context).pushNamed('/assignment/detail');
          },
        ),
        builder: (context, snapshot) {
          return ProviderListener(
            provider: authExceptionProvider,
            onChange: (context, StateController<CustomException?> error) {
              if (error.state != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      error.state!.message ?? 'Whoops... terjadi kesalahan',
                    ),
                  ),
                );
              }
            },
            child: auth.when(
              data: (user) => user == null ? LoginScreen() : HomeScreen(),
              loading: () => Splash(),
              error: (_, __) => LoginScreen(),
            ),
          );
        });
  }
}
