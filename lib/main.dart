import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'logic/logic.dart';
import 'ui/homescreen.dart';
import 'ui/ui_components.dart';
import 'ui/splashscreen.dart';
import 'ui/searchscreen.dart';
import 'ui/detailsscreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavIndexProvider()),
        ChangeNotifierProvider(create: (_) => LikeButtonColorProvider()),
      ],
      child: MyApp(),
    ),
  );
  //testAsyncFunction();
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: MyAppRoutes()._router,
    );
  }
}

class MyAppRoutes {
  final GoRouter _router = GoRouter(
    initialLocation: '/splash',
    errorPageBuilder: (BuildContext context, state) => MaterialPage(
      key: state.pageKey,
      child: Scaffold(
        body: Center(
          child: Text(
            'Error: ${state.error}',
          ),
        ),
      ),
    ),
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: '/splash',
        builder: (BuildContext context, state) => SplashScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (BuildContext context, state) => HomeScreen(),
      ),
      GoRoute(
        path: '/search',
        builder: (BuildContext context, state) => SearchScreen(),
      ),
      GoRoute(
        path: '/details/:id',
        builder: (BuildContext context, state) {
          final movieId = state.pathParameters['id'];
          return DetailsScreen(movieID: movieId!);
        },
      ),
    ],
  );
}

 class LikeButtonColorProvider extends ChangeNotifier {
  bool _isLiked = false;

  bool get isLiked => _isLiked;

  void toggleLiked() {
    _isLiked = !_isLiked;
    notifyListeners();
  }
}
// Future<void> testAsyncFunction() async {
//   Movie? inception = await getMovieByID('tt1375666');
//   print(inception?.title);

//   print('Testing asynchronous function called!');
//   print('calling the getMovieByTitle');
//   searchMovieResults? searchResults = await getMovieByTitle('Harry Potter');
//   print('fucntion called successfully');
//   List<MovieResults>? movieResults = searchResults?.movieResults;
//   print(movieResults);
//   // Example: Await an asynchronous operation
//   await Future.delayed(Duration(seconds: 1));
//   print('Async operation completed!');
// }