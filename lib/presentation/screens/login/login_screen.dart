import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _loading = true);

      await Future<void>.delayed(const Duration(seconds: 2)); // Mock API call

      setState(() => _loading = false);

      // Navigate to Dashboard after login
      if(mounted) {
        await Navigator.pushReplacementNamed(context, '/dashboard');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Login', style: Theme
                            .of(context)
                            .textTheme
                            .headlineLarge),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator: (val) =>
                          val != null && val.contains('@')
                              ? null
                              : 'Invalid email',
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                              labelText: 'Password'),
                          obscureText: true,
                          validator: (val) =>
                          val != null && val.length >= 6 ? null : 'Min 6 chars',
                        ),
                        const SizedBox(height: 20),
                        if (_loading) const CircularProgressIndicator() else ElevatedButton(
                          onPressed: _login,
                          child: const Text('Login'),
                        ),
                      ],

                    ))))
    );
  }

}