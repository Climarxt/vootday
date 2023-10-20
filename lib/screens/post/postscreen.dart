import 'package:bootdv2/screens/profile/bloc/profile_bloc.dart';
import 'package:bootdv2/widgets/appbar/appbar_post.dart';
import 'package:bootdv2/widgets/profileimagepost.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.white, // Changer à la couleur souhaitée
          statusBarIconBrightness: Brightness
              .dark, // Utilisez `Brightness.dark` pour des icônes sombres si vous avez une couleur de barre d'état claire
        ),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/images/postImage.jpg",
                      width: size.width,
                      fit: BoxFit.fitWidth,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 18, right: 18),
                      child: Row(
                        children: [
                          ProfileImagePost(
                            username: 'Username',
                            profileUrl: 'assets/images/profile2.jpg',
                          ),
                          Spacer(),
                          Column(
                            children: [
                              SizedBox(height: 12),
                              Icon(Icons.more_vert,
                                  color: Colors.black, size: 24),
                              SizedBox(height: 32),
                              Icon(Icons.comment,
                                  color: Colors.black, size: 24),
                              SizedBox(height: 32),
                              Icon(Icons.share,
                                  color: Colors.black, size: 24),
                              SizedBox(height: 32),
                              Icon(Icons.add_to_photos,
                                  color: Colors.black, size: 24),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
        
                // AppBar personnalisée
                const Positioned(
                  top: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: AppBarPost(),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
