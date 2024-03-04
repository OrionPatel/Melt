class RiveModel {
  final String src, artboard, stateMachineName;

  RiveModel({
    required this.src,
    required this.artboard,
    required this.stateMachineName,
  });
}
List<RiveModel> bottomNavItems = [
  RiveModel(
      src: "assets/animated-icons.riv",
      artboard: "HOME",
      stateMachineName: "HOME_Interactivity"),
  RiveModel(
      src: "assets/animated-icons.riv",
      artboard: "SEARCH",
      stateMachineName: "SEARCH_Interactivity"),
  RiveModel(
      src: "assets/animated-icons.riv",
      artboard: "USER",
      stateMachineName: "USER_Interactivity"),
];
