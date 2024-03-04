import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:melt_1/models/movie_model.dart';
import 'package:melt_1/services/apiservice.dart';
import 'package:provider/provider.dart';
import 'package:melt_1/logic/logic.dart';
import 'package:melt_1/main.dart';

class MovieGrid extends StatelessWidget {
  final List<String> movieIds;
  final List<bool> likeButtonStates;

 

  const MovieGrid(
      {Key? key, required this.movieIds, required this.likeButtonStates})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 8,
      ),
      itemCount: 1,
      itemBuilder: (context, index) {
        return FutureBuilder<Movie?>(
          future: getMovieByID(movieIds[index]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final movie = snapshot.data!;

              return ChangeNotifierProvider(
                create: (_) => LikeButtonColorProvider(),
                child: Consumer<LikeButtonColorProvider>(
                    builder: (context, likebuttonProvider, _) {
                 
                  return GridTile(
                    child: GestureDetector(
                      onTap: () {
                        final movieId = movie.imdbId;
                        GoRouter.of(context).go('/details/$movieId');
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(138, 63, 63, 63)
                                .withOpacity(0.7),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.45),
                                  offset: const Offset(0, 25),
                                  blurRadius: 20),
                            ]),
                        child: Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Image.network(movie.imagesUrl!.first,
                                      fit: BoxFit.cover
                                      // Ensure the image fits within the constraints
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(movie.title ?? 'Title not available',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                    textAlign: TextAlign.left),
                                SizedBox(height: 4),
                                Text(movie.year ?? 'Year not available',
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center),
                                SizedBox(height: 4),
                              ],
                            ),
                            Positioned(
                              top: 8, // Adjust top position as needed
                              right: 8, // Adjust right position as needed
                              child: Consumer<LikeButtonColorProvider>(
                                  builder: (context, likeButtonProvider, _) {
                                    return IconButton(
                                      icon: Icon(
                                        Icons.favorite,
                                         color: likeButtonProvider.isLiked ? Colors.red : Colors.white,
                                  ),
                                  onPressed: () {
                                    likeButtonProvider.toggleLiked();
                                      },
                                    );
                                  },
                                ),),
                            
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              );
            } else {
              return Container();
            }
          },
        );
      },
    );
  }
}



class AnimatedBar extends StatelessWidget {
  const AnimatedBar({super.key, required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.only(bottom: 2),
      height: 4,
      width: isActive ? 20 : 0,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
