import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:rive/rive.dart';
import 'package:melt_1/logic/logic.dart';
import 'package:melt_1/models/movie_model.dart';
import 'package:melt_1/models/rive_model.dart';
import 'package:melt_1/services/apiservice.dart';
import 'package:melt_1/ui/ui_components.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<SMIBool> riveIconInputs = [];
  List<StateMachineController?> controllers = [];
  int selctedNavIndex = 0;

  void navigateToScreen(BuildContext context, int index) {
    final List<String> pageKeys = ['/home', '/search', '/details'];
    final String destination = pageKeys[index];

    // Get the current route path
    final currentRoute = GoRouter.of(context).namedLocation;

    // If already on the selected screen, do nothing
    if (currentRoute == destination) {
      return;
    }

    // Navigate to the selected screen
    GoRouter.of(context).go(destination);
  }

  void animateTheIcon(int index) {
    riveIconInputs[index].change(true);
    Future.delayed(
      const Duration(seconds: 1),
      () {
        riveIconInputs[index].change(false);
      },
    );
  }

  void riveOnInIt(Artboard artboard, {required String stateMachineName}) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, stateMachineName);

    artboard.addController(controller!);
    controllers.add(controller);

    riveIconInputs.add(controller.findInput<bool>('active') as SMIBool);
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NavIndexProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 30, 0, 0),
        title: const Text(
          'MELT',
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          // height: 56, //TODO: in future remove height
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/navbar.png'),
              fit: BoxFit.cover,),),
          child: Consumer<NavIndexProvider>(
            builder: (context, provider, _) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(bottomNavItems.length, (index) {
                final riveIcon = bottomNavItems[index];
                return GestureDetector(
                  onTap: () {
                    animateTheIcon(index);
                    provider.setIndex(index);
                    navigateToScreen(context, index);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedBar(isActive: provider.selectedIndex == index),
                      SizedBox(
                        height: 36,
                        width: 36,
                        child: Opacity(
                          opacity: provider.selectedIndex == index ? 1 : 0.5,
                          child: RiveAnimation.asset(
                            riveIcon.src,
                            artboard: riveIcon.artboard,
                            onInit: (artboard) {
                              riveOnInIt(artboard,
                                  stateMachineName: riveIcon.stateMachineName);
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/homescreen.png'))),
        child: FutureBuilder<List<String>?>(
          future: getNowPlaying(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final movieIds = snapshot.data!;
              final likeButtonStates =
                  List.generate(movieIds.length, (index) => false);
              return MovieGrid(
                  movieIds: snapshot.data!, likeButtonStates: likeButtonStates);
            } else {
              return Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(56, 0, 0, 0).withOpacity(0.7),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.45),
                          offset: const Offset(0, 25),
                          blurRadius: 20),
                    ]),
                child: const Center(
                    child: Text(
                  'No data available',
                  style: TextStyle(color: Colors.amber),
                )),
              );
            }
          },
        ),
      ),
    );
  }
}
class LikeButtonColorProvider extends ChangeNotifier {
  bool _isLiked = false;

  bool get isLiked => _isLiked;

  void toggleLiked() {
    _isLiked = !_isLiked;
    notifyListeners();
  }
}



