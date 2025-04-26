import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_machinetask/view_models/auth_view_model.dart';
import 'package:todo_list_machinetask/views/home_screen.dart';
import 'package:todo_list_machinetask/views/signup_screen.dart';
import 'package:todo_list_machinetask/widgets/custom_smooth_navigator.dart';
import 'package:todo_list_machinetask/widgets/custom_text_field.dart';
import 'package:todo_list_machinetask/widgets/responsive_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    // if (authViewModel.isLoggedIn) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     Navigator.of(context).pushReplacement(
    //         MaterialPageRoute(builder: (context) => const HomeScreen()));
    //   });
    // }
    return Scaffold(
      body: ResponsiveLayout(
        mobileLayout: _buildMobileLayout(authViewModel),
        tabletLayout: _buildTabletLayout(authViewModel),
        desktopLayout: _buildDesktopLayout(authViewModel),
      ),
    );
  }

  Widget _buildLoginForm(AuthViewModel authViewModel) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Welcome Back',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sign in to continue',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey,
                ),
          ),
          const SizedBox(height: 32),
          CustomTextfield(
            controller: _emailController,
            hintText: 'Enter Email',
            labelText: 'Email',
            isPassword: false,
            prefixIcon: const Icon(Icons.email_outlined),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          // TextFormField(
          //   controller: _emailController,
          //   decoration: const InputDecoration(
          //     labelText: 'Email',
          //     border: OutlineInputBorder(),
          //     prefixIcon: Icon(Icons.email_outlined),
          //   ),
          //   keyboardType: TextInputType.emailAddress,
          //   validator:
          // ),
          const SizedBox(height: 16),
          CustomTextfield(
            controller: _passwordController,
            hintText: 'Enter Password',
            labelText: 'Password',
            isPassword: true,
            obscureText: true,
            prefixIcon: const Icon(Icons.lock_outline),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          // TextFormField(
          //   controller: _passwordController,
          //   decoration: const InputDecoration(
          //     labelText: 'Password',
          //     border: OutlineInputBorder(),
          //     prefixIcon: Icon(Icons.lock_outline),
          //   ),
          //   obscureText: true,
          //   validator: (value) {
          //     if (value == null || value.isEmpty) {
          //       return 'Please enter your password';
          //     }
          //     if (value.length < 6) {
          //       return 'Password must be at least 6 characters';
          //     }
          //     return null;
          //   },
          // ),
          if (authViewModel.errorMessage != null) ...[
            const SizedBox(height: 16),
            Text(
              authViewModel.errorMessage!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: authViewModel.isLoading
                ? null
                : () async {
                    if (_formKey.currentState!.validate()) {
                      final success = await authViewModel.signIn(
                        _emailController.text.trim(),
                        _passwordController.text,
                      );
                      if (success && context.mounted) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                        );
                      }
                    }
                  },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: authViewModel.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Login'),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account? ",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              GestureDetector(
                onTap: () {
                  CustomSmoothNavigator.push(context, SignupScreen());
                },
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(AuthViewModel authViewModel) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: _buildLoginForm(authViewModel),
          ),
        ),
      ),
    );
  }

  Widget _buildTabletLayout(AuthViewModel authViewModel) {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.all(24.0),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: _buildLoginForm(authViewModel),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(AuthViewModel authViewModel) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            color: Theme.of(context).colorScheme.primary,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.task_alt,
                    size: 100,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Todo App',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Manage your tasks efficiently',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimary
                              // ignore: deprecated_member_use
                              .withOpacity(0.8),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Padding(
                padding: const EdgeInsets.all(48.0),
                child: _buildLoginForm(authViewModel),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
