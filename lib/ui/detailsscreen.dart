import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:rive/rive.dart';
import 'package:melt_1/logic/logic.dart';
import 'package:melt_1/models/movie_model.dart';
import 'package:melt_1/models/rive_model.dart';
import 'package:melt_1/services/apiservice.dart';
import 'package:melt_1/ui/ui_components.dart';

class DetailsScreen extends StatefulWidget {
  final String movieID;
  const DetailsScreen({super.key, required this.movieID});
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}
class _DetailsScreenState extends State<DetailsScreen> {
  late Future<Movie?> _movieDetails;

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
  void initState() {
    super.initState();
    _movieDetails = getMovieByID(widget.movieID);
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Container(
          // height: 56, //TODO: in future remove height
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.redAccent.withOpacity(0.8),
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.redAccent.withOpacity(0.3),
                offset: const Offset(0, 20),
                blurRadius: 20,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(bottomNavItems.length, (index) {
              final riveIcon = bottomNavItems[index];
              return GestureDetector(
                onTap: () {
                  animateTheIcon(index);
                  
                  navigateToScreen(context, index);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBar(isActive: selctedNavIndex == index),
                    SizedBox(
                      height: 36,
                      width: 36,
                      child: Opacity(
                        opacity: selctedNavIndex == index ? 1 : 0.5,
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
      floatingActionButton: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () {
          navigateToScreen(context, 0);
        },
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<Movie?>(
        future: _movieDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final movie = snapshot.data!;
            return Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/detailsscreen.png'))),
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

}