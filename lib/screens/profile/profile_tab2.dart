import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/profile/bloc/blocs.dart';
import 'package:bootdv2/screens/profile/widgets/widgets.dart';

import 'package:flutter/material.dart';


class ProfileTab2 extends StatefulWidget {
  final BuildContext context;
  final ProfileState state;

  const ProfileTab2(
      {super.key, required this.context, required this.state});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileTab2State createState() => _ProfileTab2State();
}

class _ProfileTab2State extends State<ProfileTab2>
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
  return Container(
    color: white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ButtonsSection(state: state),
        LocationSection(location: state.user.location),
        const SocialNetSection(),
        AboutSection(state: state),
      ],
    ),
  );
}
