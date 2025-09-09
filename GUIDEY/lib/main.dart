import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guidey/my_page.dart';
import 'package:guidey/quiz/quiz_cubit.dart';
import 'package:guidey/quiz/quiz_page.dart';
import 'package:guidey/career_search_page.dart';
import 'package:guidey/quiz/quiz_state.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:guidey/screen_one.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => QuizCubit(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizCubit, QuizState>(
      builder: (context, state) {
        var cubit = context.read<QuizCubit>();

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: cubit.isDark ? ThemeData.dark() : ThemeData.light(),

          // هنا علشان الـ locale يشتغل صح
          locale: Locale(cubit.currentLanguage),

          // لازم تدعمي الـ localization
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
          ],

          initialRoute: '/my_page',
          routes: {
            '/quiz': (context) => QuizScreen(),
            '/search': (context) => CareerSearchPage(),
            '/my_page': (context) => PageOne(),
          },
        );
      },
    );
  }
}