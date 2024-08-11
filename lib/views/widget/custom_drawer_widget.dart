import 'package:crud_interview/blocs/image_bloc/image_bloc.dart';
import 'package:crud_interview/blocs/user_bloc/user_bloc.dart';
import 'package:crud_interview/utils/secure_storage.dart';
import 'package:crud_interview/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.paddingOf(context).top,
              left: 20,
              bottom: 20,
              right: 20,
            ),
            color: Colors.green, // Background color of the drawer header

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<ImageBloc, ImageState>(
                      builder: (context, state) {
                        if (state is ImageSuccess) {
                          if (state.imageFile != null) {
                            return CircleAvatar(
                              backgroundImage: FileImage(state.imageFile!),
                              radius: 40.0,
                            );
                          }
                        }
                        return const CircleAvatar(
                          radius: 40.0,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            color: Colors.green,
                            size: 40,
                          ),
                        );
                      },
                    ),
                    BlocBuilder<UserBloc, UserState>(
                      builder: (context, state) {
                        if (state is UserSuccess) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              Text(
                                state.userModel!.name,
                                style: GoogleFonts.inter(
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                '0${state.userModel!.phone}',
                                style: GoogleFonts.inter(
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt, color: Colors.white),
                  onPressed: () {
                    context.read<ImageBloc>().add(
                          const PickImageEvent(
                            source: ImageSource.gallery,
                          ),
                        );
                  },
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              // Handle logout action
              await SecureStorage.deleteToken();

              context.read<ImageBloc>().add(RemoveImageEvent());

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginView(),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
