import 'package:flutter/material.dart';
import 'package:todo_list_machinetask/view_models/auth_view_model.dart';
import 'package:todo_list_machinetask/views/login_screen.dart';
import 'package:todo_list_machinetask/widgets/custom_smooth_navigator.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  CustomAppBar({super.key}) : preferredSize = Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 4.0, 
      title: Text(
        'Todo App', 
        style: TextStyle(
          fontSize: 22.0, 
          fontWeight: FontWeight.w600, 
          letterSpacing: 1.0, 
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.logout), 
          onPressed: () async {
            final authViewModel = AuthViewModel();
            await authViewModel.signOut(); 
            if (context.mounted) {
              CustomSmoothNavigator.pushReplacement(
                  context, LoginScreen()); 
            }
          },
        ),
      ],
    );
  }
}
