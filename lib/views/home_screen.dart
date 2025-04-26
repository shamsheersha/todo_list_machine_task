import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_machinetask/view_models/auth_view_model.dart';
import 'package:todo_list_machinetask/views/login_screen.dart';
import 'package:todo_list_machinetask/widgets/custom_smooth_navigator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(
              'Welcome to the Home Screen!',
              style: TextStyle(fontSize: 24),
            ),
            TextButton(onPressed: (){
              AuthViewModel authViewModel = Provider.of<AuthViewModel>(context, listen: false);
              authViewModel.signOut();
              CustomSmoothNavigator.pushReplacement(context, LoginScreen());
            }, child: Text('Logout')),
            
          ],
        ),
      ),
    );
  }
}