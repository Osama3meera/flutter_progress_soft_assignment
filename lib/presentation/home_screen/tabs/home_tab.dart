import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osama_hasan_progress_soft/presentation/home_screen/bloc/home_bloc.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(GetPostsStartedEvent());
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      context.read<HomeBloc>().add(GetPostsStartedEvent());
    } else {
      context.read<HomeBloc>().add(FilterPostsEvent(query));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.name,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              labelText: 'search'.tr(),
              border: const OutlineInputBorder(
                borderSide: BorderSide(),
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: BlocConsumer<HomeBloc, HomeState>(
              listener: (context, state) {},
              buildWhen: (previous, current) =>
                  current is GetPostSuccessState ||
                  current is GetPostErrorState ||
                  current is GetPostLoadingState,
              builder: (context, state) {
                if (state is GetPostSuccessState) {
                  return ListView.builder(
                    itemCount: state.posts.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(state.posts[index].title),
                        subtitle: Text(state.posts[index].body),
                        trailing: Text(state.posts[index].id.toString()),
                      );
                    },
                  );
                } else if (state is GetPostErrorState) {
                  return Center(
                    child: Text(
                      'error'.tr(),
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                } else if (state is GetPostLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
