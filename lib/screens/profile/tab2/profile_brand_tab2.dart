import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/profile/bloc/blocs.dart';
import 'package:bootdv2/screens/profile/widgets/widgets.dart';

import 'package:flutter/material.dart';

class ProfileBrandTab2 extends StatefulWidget {
  final BuildContext context;
  final ProfileState state;

  const ProfileBrandTab2(
      {super.key, required this.context, required this.state});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileBrandTab2State createState() => _ProfileBrandTab2State();
}

class _ProfileBrandTab2State extends State<ProfileBrandTab2>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _buildListView(widget.context, widget.state);
  }
}

Widget _buildListView(BuildContext context, ProfileState state) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
    child: Container(
      color: white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ButtonsSection(state: state),
          LocationSection(location: state.user.locationCity),
          SocialNetSection(state: state),
          AboutSection(state: state),
        ],
      ),
    ),
  );
}
