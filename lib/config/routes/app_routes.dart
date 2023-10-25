import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:spotify_clone/presentation/home/view/home.dart';
import 'package:spotify_clone/presentation/login/view/login.dart';

class AppRouter {
  const AppRouter._();
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case LoginPage.routeName:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case HomePage.routeName:
        return PageTransition(
          child: const HomePage(),
          type: PageTransitionType.topToBottom,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCirc,
          settings: settings,
        );
      // return MaterialPageRoute(
      //   builder: (_) => BlocBuilder<ThemeCubit, ThemeState>(
      //     builder: (context, state) {
      //       return MultiBlocProvider(
      //         providers: [
      //           BlocProvider.value(
      //             value: context.read<ThemeCubit>(),
      //           ),
      //           BlocProvider(
      //             create: (context) => DownloadPathCubit(),
      //           ),
      //         ],
      //         child: const Settings(),
      //       );
      //     },
      //   ),
      // );
      default:
        throw const Scaffold(
          body: Center(
            child: Text('Route not found!'),
          ),
        );
    }
  }
}
