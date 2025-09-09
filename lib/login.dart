import 'package:flutter/material.dart';
import 'package:guidey/my_page.dart';
import 'package:guidey/api.dart';
import 'package:guidey/global_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;
  bool _isLoading = false;
  final GlobalState _globalState = GlobalState();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {

      print('🔍 Testing API connection...');
      final isConnected = await ApiService().testConnection();
      
      if (isConnected) {

        print('✅ Connection successful, using API...');
        final result = await ApiService().loginUser(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        if (mounted) {

          if (result['token'] != null) {
            await _globalState.setAuthToken(result['token']);
            await _globalState.setUserProfile(result);
          }




          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyPage()),
          );
        }
      } else {

        print('⚠️ Server offline, using local mode...');
        

        final localUser = {
          'email': _emailController.text.trim(),
          'is_local': true,
          'username': _emailController.text.trim().split('@')[0],
          'full_name': 'Local User',
        };
        

        await _globalState.setUserProfile(localUser);
        await _globalState.setAuthToken('local_token_${DateTime.now().millisecondsSinceEpoch}');
        
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyPage()),
          );
        }
      }
      
    } on ApiException catch (e) {

      print('⚠️ API Error, using local mode: ${e.message}');
      
      final localUser = {
        'email': _emailController.text.trim(),
        'is_local': true,
        'username': _emailController.text.trim().split('@')[0],
        'full_name': 'Local User',
      };
      

      await _globalState.setUserProfile(localUser);
      await _globalState.setAuthToken('local_token_${DateTime.now().millisecondsSinceEpoch}');
      
      if (mounted) {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyPage()),
        );
      }
      
    } on NetworkException catch (e) {
      print('⚠️ Network Error, using local mode: ${e.message}');
      
      final localUser = {
        'email': _emailController.text.trim(),
        'is_local': true,
        'username': _emailController.text.trim().split('@')[0],
        'full_name': 'Local User',
      };

      await _globalState.setUserProfile(localUser);
      await _globalState.setAuthToken('local_token_${DateTime.now().millisecondsSinceEpoch}');
      
      if (mounted) {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyPage()),
        );
      }
      
    } catch (e) {
      print('⚠️ Unexpected Error, using local mode: $e');
      
      final localUser = {
        'email': _emailController.text.trim(),
        'is_local': true,
        'username': _emailController.text.trim().split('@')[0],
        'full_name': 'Local User',
      };

      await _globalState.setUserProfile(localUser);
      await _globalState.setAuthToken('local_token_${DateTime.now().millisecondsSinceEpoch}');
      
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyPage()),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [Color(0xFF3DAEE9), Color(0xFF8A6FE8)],
            ),
          ),
        ),
        title: const Center(
          child: Text(
            "Welcome Back!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Email
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email Address",
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),


                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_showPassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),


                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('سيتم إضافة هذه الميزة قريباً'),
                            backgroundColor: Colors.blue,
                          ),
                        );
                      },
                      child: const Text(
                        'Forgot your password?',
                        style: TextStyle(color: Colors.purple),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),


                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _signIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple[800],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text("Signing In..."),
                              ],
                            )
                          : const Text(
                              'Sign In',
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}