import 'package:appdev/components/forgetpassdialog.dart';
import 'package:appdev/pages/documents.dart';
import 'package:appdev/pages/login.dart';
import 'package:appdev/pages/register.dart';
import 'package:appdev/pages/reset_password.dart';
import 'package:appdev/pages/tabs.dart';
import 'package:appdev/pages/upload_docs.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
        url: 'https://dzsweolrpmfwdjqvtnni.supabase.co',
        anonKey:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR6c3dlb2xycG1md2RqcXZ0bm5pIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg4MjkwODksImV4cCI6MjA1NDQwNTA4OX0.FmLD4bx5KCCEDIxBFBbqxOBiUT3KwOHcIT2iOwhvGgU');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Future.delayed(Duration.zero, () {
      if (mounted) {
        configureDeepLink(context);
      }
    });
  });
}

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 255, 255)),
        useMaterial3: true,
      ),
      initialRoute: '/login',
        routes: {
        '/tabs': (context) =>   TabsScreen(),
        '/login': (context) =>   LoginPage(),
        '/signup': (context) =>  RegisterPage(),
        '/uploadDocs': (context) =>  UploadPage(),
        '/myDocs': (context) =>  MyDocuments(),
        '/updatepasswordpage': (context) =>  UpdatePasswordPage()

      },
    );
  }
}

