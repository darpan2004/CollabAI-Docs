import 'package:collab_ai_docs/colors.dart';
import 'package:collab_ai_docs/models/error_model.dart';
import 'package:collab_ai_docs/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../repository/auth_repository.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);
  void signInWithGoogle (WidgetRef ref,BuildContext context) async{
    final sMessenger=ScaffoldMessenger.of(context);
    final navigator =Routemaster.of(context);
  final errorModel=await   ref.read(authRepositoryProvider).signInWithGoogle();
  if(errorModel.error==null){
    ref.read(userProvider.notifier).update((state)=>errorModel.data);
    navigator.replace('/');
  }else{
sMessenger.showSnackBar(
      SnackBar(
        content: Text(errorModel.error!),
      ),
    );
  }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch(authRepositoryProvider).signInWithGoogle();

    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => signInWithGoogle(ref,context),
          icon: Image.asset(
            'assets/images/g-logo-2.png',
            height: 24.0,
          ),
          label: const Text(
            'Sign in with Google',
            style: TextStyle(color: kBlackColor),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: kWhiteColor,
            minimumSize: const Size(150.0, 48.0),
          ),
        ),
      ),
    );
  }
}
