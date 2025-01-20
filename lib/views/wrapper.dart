import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_shop_admin/views/bottom_nav_wrapper.dart';

import '../provider/auth_handel.dart';
import 'dashboard.dart';
import 'auth_screen.dart';

class WrapperScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: Auth.isAuthenticated(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data == true) {
          return BottomNavWrapper(); // Navigate to Dashboard if authenticated
        } else {
          return AuthScreen(); // Navigate to AuthScreen if not authenticated
        }
      },
    );
  }
}
