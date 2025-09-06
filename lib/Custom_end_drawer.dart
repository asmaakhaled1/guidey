import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guidey/quiz/quiz_cubit.dart';
import 'package:guidey/quiz/quiz_state.dart';
import 'package:guidey/screen_one.dart';
import 'package:guidey/global_state.dart';

class CustomEndDrawer extends StatefulWidget {
  const CustomEndDrawer({super.key});

  @override
  State<CustomEndDrawer> createState() => _CustomEndDrawerState();
}

class _CustomEndDrawerState extends State<CustomEndDrawer> {
  final GlobalState _globalState = GlobalState();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await _globalState.checkAuthStatus();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _logout() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _globalState.logout();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => PageOne()),
              (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في تسجيل الخروج: $e'),
            backgroundColor: Colors.red,
          ),
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
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3DAEE9), Color(0xFF8A6FE8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Color(0xFF8A6FE8),
                  ),
                ),
                if (_globalState.isAuthenticated && _globalState.fullName != null)
                  Text(
                    _globalState.fullName!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                else
                  Text(
                    'Guest User',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (_globalState.isAuthenticated && _globalState.email != null)
                  Text(
                    _globalState.email!,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),

          if (_globalState.isAuthenticated) ...[
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('سيتم إضافة صفحة الملف الشخصي قريباً'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('سيتم إضافة صفحة الإعدادات قريباً'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
            ),
          ],


          BlocBuilder<QuizCubit, QuizState>(
            builder: (context, state) {
              final cubit = context.read<QuizCubit>();
              return SwitchListTile(
                secondary: const Icon(Icons.dark_mode),
                title: const Text('Dark Mode'),
                value: cubit.isDark,
                onChanged: (_) => cubit.toggleTheme(),
              );
            },
          ),

          Divider(),

          if (_globalState.isAuthenticated)
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.red[900],
              ),
              title: Text(
                'Log Out',
                style: TextStyle(color: Colors.red[900]),
              ),
              onTap: _isLoading ? null : _logout,
              trailing: _isLoading
                  ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red[900]!),
                ),
              )
                  : null,
            )
          else
            ListTile(
              leading: Icon(
                Icons.login,
                color: Colors.green[700],
              ),
              title: Text(
                'Sign In',
                style: TextStyle(color: Colors.green[700]),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PageOne()),
                );
              },
            ),

          SizedBox(height: 20),

          // App Info
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Text(
                  'GUIDEY v1.0.0',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Your AI Career Guide',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}