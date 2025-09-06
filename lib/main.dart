import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'quiz/quiz_cubit.dart';
import 'quiz/quiz_state.dart';
import 'quiz/lang_prov.dart';
import 'quiz/quiz_page.dart';
import 'auth_wrapper.dart';
import 'career_search_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690), // 📱 مقاس التصميم الأساسي
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocProvider(
          create: (context) => QuizCubit(
            langProvider: context.read<LanguageProvider>(),
          ),
          child: BlocBuilder<QuizCubit, QuizState>(
            builder: (context, state) {
              var cubit = context.read<QuizCubit>();

              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: cubit.isDark ? ThemeData.dark() : ThemeData.light(),
                locale: Locale(cubit.langProvider.currentLangCode),
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('en'),
                  Locale('ar'),
                ],
                initialRoute: '/',
                routes: {
                  '/': (context) => AuthWrapper(),
                  '/quiz': (context) => QuizScreen(),
                  '/search': (context) => CareerSearchPage(),
                },
              );
            },
          ),
        );
      },
    );
  }
}
