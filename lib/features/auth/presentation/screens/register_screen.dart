import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Center(
        child: Text('Register Screen — coming next 🔥',
            style: TextStyle(color: AppColors.textSecondary)),
      ),
    );
  }
}
