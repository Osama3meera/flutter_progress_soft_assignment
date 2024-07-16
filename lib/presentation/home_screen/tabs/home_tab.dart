import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osama_hasan_progress_soft/presentation/home_screen/bloc/home_bloc.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

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
              children: [Text('Home Screen')],
            );
          },
        ),
      ),
    );
  }
}
