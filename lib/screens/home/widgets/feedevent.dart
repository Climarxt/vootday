import 'package:bootdv2/config/configs.dart';
import 'package:flutter/material.dart';

class FeedEvent extends StatefulWidget {
  const FeedEvent({super.key});

  @override
  _FeedEventState createState() => _FeedEventState();
}

class _FeedEventState extends State<FeedEvent> {
  List<String> imageList = [
    'assets/images/postImage.jpg',
    'assets/images/postImage2.jpg',
    'assets/images/ITG1_1.jpg',
    'assets/images/ITG1_2.jpg',
    'assets/images/ITG3_1.jpg',
    'assets/images/ITG3_2.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          childAspectRatio: 0.8,
        ),
        itemCount: imageList.length,
        itemBuilder: (context, index) {
          return _buildCard(context, imageList[index]);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Calendar'),
        backgroundColor: couleurBleuClair2,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildCard(BuildContext context, String imageUrl) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      child: SizedBox(
        height: size.height * 0.6,
        width: size.width,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              _buildPost(imageUrl),
              Positioned(
                bottom: 10,
                left: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Titre',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(color: white),
                    ),
                    Text('Description',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: white))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPost(String imageUrl) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: AssetImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: const Alignment(0, 0.33),
              colors: [
                Colors.black.withOpacity(0.8),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
