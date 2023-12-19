import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/comment/widgets/widgets.dart';
import 'package:bootdv2/screens/search/cubit/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchingScreen extends StatelessWidget {
  const SearchingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchCubit, SearchState>(
      listener: (context, state) {
        if (state.status == SearchStatus.initial) {
          context.read<SearchCubit>();
        }
      },
      builder: (context, state) {
        return _buildBody(state, context);
      },
    );
  }

  Widget _buildBody(SearchState state, BuildContext context) {
    return Scaffold(
      appBar: AppBarComment(
        title: AppLocalizations.of(context)!.translate('search'),
      ),
      body: const Center(
        child: Text(
          'Work In Progress',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
