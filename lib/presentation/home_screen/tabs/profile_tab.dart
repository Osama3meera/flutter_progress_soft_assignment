import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osama_hasan_progress_soft/presentation/home_screen/bloc/home_bloc.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            // Listener logic here
          },
          builder: (context, state) {
            // Builder logic here
            return Column(
              children: [Text('Profle Screen')],
            );
          },
        ),
      ),
    );
  }
}
