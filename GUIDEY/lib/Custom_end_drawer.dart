import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guidey/quiz/quiz_cubit.dart';
import 'package:guidey/quiz/quiz_state.dart';
import 'package:guidey/screen_one.dart';

class CustomEndDrawer extends StatelessWidget {
  const CustomEndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Theme.of(context).primaryColor),
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('You'),
            onTap: () {},
          ),

          // تغيير اللغة
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            onTap: () {
              // مثال بسيط: يبدل بين EN و AR
              final cubit = context.read<QuizCubit>();
              cubit.changeLanguage(cubit.currentLanguage == "en" ? "ar" : "en");
            },
          ),

          // التحكم في الدارك مود
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

          ListTile(
            leading: Icon(Icons.logout, color: Colors.red[900]),
            title: Text('Log Out', style: TextStyle(color: Colors.red[900])),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PageOne()),
              );
            },
          ),
        ],
      ),
    );
  }
}