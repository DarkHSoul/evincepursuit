import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evincepursuit/providers/google-sign-in.dart';
import 'package:evincepursuit/variables.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
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
  int _counter = 0;
  final firestoreInstance = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  Future<void> _saveCounterToFirestore(int counter) async {
    final userId = auth.currentUser?.uid;

    await firestoreInstance
        .collection('users')
        .doc(userId)
        .set({'counter': counter});
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
      _saveCounterToFirestore(_counter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ValueListenableBuilder(
              valueListenable: Hive.box<Woods>('woods').listenable(),
              builder: (context, box, _) {
                final woods = box.get(0, defaultValue: Woods());
                return Text('Wood count: ${woods?.woodcount}');
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
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
