import 'package:flutter/material.dart';

import 'features/auth/presentation/auth_screen.dart';
import 'theme/bondcircle_theme.dart';

class BondCircleApp extends StatelessWidget {
  const BondCircleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BondCircle',
      debugShowCheckedModeBanner: false,
      theme: BondCircleTheme.light,
      home: const AuthScreen(),
    );
  }
}
