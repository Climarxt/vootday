class Highlight {
  final String name, image;

  Highlight({
    required this.name,
    required this.image,
  });

  static List<Highlight> get highlights => [
        Highlight(
          name: "Reels",
          image: 'assets/images/ITG1_1.jpg',
        ),
        Highlight(
          name: "2x Speed 🚀",
          image: 'assets/images/ITG1_1.jpg',
        ),
        Highlight(
          name: "Tips",
          image: 'assets/images/ITG1_1.jpg',
        ),
        Highlight(
          name: "Packages",
          image: 'assets/images/ITG1_1.jpg',
        ),
        Highlight(
          name: "Quotes",
          image: 'assets/images/ITG1_1.jpg',
        ),
        Highlight(
          name: "Resume",
          image: 'assets/images/ITG1_1.jpg',
        ),
        Highlight(
          name: "Learn Flutter",
          image: 'assets/images/ITG1_1.jpg',
        ),
      ];
}
