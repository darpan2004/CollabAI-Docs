import 'package:collab_ai_docs/models/error_model.dart';
import 'package:collab_ai_docs/repository/auth_repository.dart';
import 'package:collab_ai_docs/router.dart';
import 'package:collab_ai_docs/screens/home_screen.dart';
import 'package:collab_ai_docs/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const ProviderScope(child:  MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  ErrorModel? errorModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }
  void getUserData()async{
 errorModel=await   ref.read(authRepositoryProvider).getUserData();
    if(errorModel!=null&&errorModel!.data!=null){
      ref.read(userProvider.notifier).update((state)=>errorModel!.data);  
    } 
  }
  // This widget is the root of your application.
  
  @override
  Widget build(BuildContext context) {
    final user=ref.watch(userProvider);
    return MaterialApp.router(
      localizationsDelegates: const [
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    FlutterQuillLocalizations.delegate,
  ],
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
            final user = ref.watch(userProvider);
            if (user != null && user.token.isNotEmpty) {
              return loggedInRoute;
            } else {
              return loggedOutRoute;
            }
      }),
      routeInformationParser: const RoutemasterParser(),
    );
  }
}
