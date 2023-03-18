import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evincepursuit/providers/google-sign-in.dart';
import 'package:evincepursuit/variables.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'Settings/settings.dart';

SnackBar? snackboi;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);
  await Hive.initFlutter();
  await Hive.openBox('themedata');
  Hive.registerAdapter(WoodsAdapter());
  Hive.registerAdapter(StoneAdapter());
  await Hive.openBox<Woods>('woods');
  await Hive.openBox<Stone>('stone');

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        title: 'Flutter Demo ',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final firestoreInstance = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  Timer? timer;

  @override
  void dispose() {
    timer?.cancel(); // cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ));
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.googleLogin();
                },
                child: const Text("Click to sign in to Google")),
            ValueListenableBuilder(
              valueListenable: Hive.box<Woods>('woods').listenable(),
              builder: (context, box, _) {
                final woods = box.get(0, defaultValue: Woods());
                final woodCutters = box.get(1, defaultValue: Woods());
                final people = box.get(2, defaultValue: Woods());
                DateTime? lastUpdateTime = DateTime.now();

                timer = Timer.periodic(
                  const Duration(seconds: 1),
                  (timer) {
                    final now = DateTime.now();
                    final elapsed =
                        now.difference(lastUpdateTime!).inMilliseconds / 1000;
                    woods!.woodcount +=
                        (woodCutters!.woodCutters * elapsed).toInt();
                    box.put(0, woods);
                    lastUpdateTime = now;
                  },
                );

                return Card(
                    child: Column(
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text('Wood count: ${woodCutters!.woodCutters} '),
                    ),
                    InkWell(
                      child: TextButton(
                          onPressed: () {
                            if (people!.people > 0) {
                              woodCutters.woodCutters++;
                              people.people--;
                              box.put(1, woodCutters);
                              box.put(2, people);
                            }
                          },
                          onLongPress: () {
                            if (woodCutters.woodCutters > 0) {
                              woodCutters.woodCutters--;
                              people!.people++;
                              box.put(1, woodCutters);
                            }
                          },
                          child:
                              Text('WoodCutters: ${woodCutters.woodCutters}')),
                    ),
                    TextButton(
                        onPressed: () {
                          people.people++;
                          box.put(2, people);
                        },
                        child: Text('People: ${people!.people}'))
                  ],
                ));
              },
            ),
            ValueListenableBuilder(
              valueListenable: Hive.box<Stone>('stone').listenable(),
              builder: (context, box, _) {
                final stone = box.get(0, defaultValue: Stone());

                box.put(0, stone!);
                return TextButton(
                    onPressed: () {
                      stone.stonecount += 1;
                      box.put(0, stone);
                    },
                    child: Text("Stone count: ${stone.stonecount}"));
              },
            ),
          ],
        ),
      ),
    );
  }
}
