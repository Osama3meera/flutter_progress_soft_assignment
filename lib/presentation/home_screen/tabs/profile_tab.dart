import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osama_hasan_progress_soft/presentation/home_screen/bloc/home_bloc.dart';
import 'package:osama_hasan_progress_soft/presentation/login_screen/bloc/login_bloc.dart';
import 'package:osama_hasan_progress_soft/presentation/login_screen/login_screen.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(GetUserInfoEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is UserLogoutState) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => LoginBloc(),
                  child: const LoginScreen(),
                ),
              ),
              (route) => false,
            );
          }
        },
        buildWhen: (previous, current) =>
            current is GetUserInfoSuccessState || current is UserLogoutState,
        builder: (context, state) {
          if (state is GetUserInfoSuccessState) {
            return Center(
              child: Column(
                children: [
                  Text(
                    state.name,
                    style: TextStyle(
                        fontSize: 26,
                        color: Colors.indigo.shade700,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 25),
                  Text(
                    state.age.toString(),
                    style: TextStyle(
                        fontSize: 26,
                        color: Colors.indigo.shade700,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 25),
                  Text(
                    state.gender,
                    style: TextStyle(
                        fontSize: 26,
                        color: Colors.indigo.shade700,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 25),
                  Text(
                    state.mobile,
                    style: TextStyle(
                        fontSize: 26,
                        color: Colors.indigo.shade700,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 80),
                  MaterialButton(
                    color: Colors.indigo,
                    textColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      child: Text('logout'.tr(),
                          style: const TextStyle(fontSize: 22)),
                    ),
                    onPressed: () {
                      context.read<HomeBloc>().add(UserLogoutEvent());
                    },
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
