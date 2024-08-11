// ignore_for_file: use_build_context_synchronously

import 'package:crud_interview/utils/image_utils.dart';
import 'package:crud_interview/utils/secure_storage.dart';
import 'package:crud_interview/views/home_view.dart';
import 'package:crud_interview/views/login_view.dart';
import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    await Future.delayed(const Duration(seconds: 3));

    final token = await SecureStorage.getToken();
    if (token != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeView()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginView()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.scale(
                scale: value,
                child: child,
              ),
            );
          },
          child: SizedBox(
            height: 350,
            width: 350,
            child: Image.asset(ImageUtils.heroSplashPNG),
          ),
        ),
      ),
    );
  }
}
