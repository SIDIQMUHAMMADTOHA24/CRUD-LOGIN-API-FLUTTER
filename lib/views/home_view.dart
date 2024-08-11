import 'package:crud_interview/blocs/employe_bloc/employe_bloc.dart';
import 'package:crud_interview/blocs/field_bloc/field_bloc.dart';
import 'package:crud_interview/blocs/user_bloc/user_bloc.dart';
import 'package:crud_interview/utils/image_utils.dart';
import 'package:crud_interview/utils/key_constant.dart';
import 'package:crud_interview/utils/secure_storage.dart';
import 'package:crud_interview/views/login_view.dart';
import 'package:crud_interview/views/widget/animated_image_widget.dart';
import 'package:crud_interview/views/widget/custom_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController fullController = TextEditingController();
  final TextEditingController jobsController = TextEditingController();
  final FocusNode focusNodeFullName = FocusNode();
  final FocusNode focusNodeJobs = FocusNode();

  @override
  void initState() {
    super.initState();

    addFocusListener(KeyConstants.fullName, focusNodeFullName);
    addFocusListener(KeyConstants.jobs, focusNodeJobs);

    context.read<EmployeBloc>().add(GetData());
    context.read<UserBloc>().add(GetUserEvent());

    context.read<FieldBloc>().add(FieldResetEvent());
  }

  //FOCUS LISTENER EVENT
  void addFocusListener(KeyConstants key, FocusNode focusNode) {
    focusNode.addListener(() {
      context
          .read<FieldBloc>()
          .add(FieldFocusEvent(key: key, hasFocus: focusNode.hasFocus));
    });
  }

  @override
  void dispose() {
    fullController.dispose();
    jobsController.dispose();
    focusNodeFullName.dispose();
    focusNodeJobs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'EMPLOYE',
          style: GoogleFonts.inter(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),

      drawer: const CustomDrawer(),

      body: BlocBuilder<EmployeBloc, EmployeState>(
        builder: (context, state) {
          if (state is EmployeSuccess) {
            if (state.listDataTodo.isEmpty) {
              return const AnimatedImage();
            }
            return ListView.builder(
              padding: EdgeInsets.only(
                  right: 20,
                  left: 20,
                  top: MediaQuery.paddingOf(context).top + 20),
              itemCount: state.listDataTodo.length,
              itemBuilder: (context, index) {
                final employee = state.listDataTodo[index];
                return Slidable(
                  key: ValueKey(employee.id),
                  endActionPane: ActionPane(
                    dragDismissible: true,
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          context
                              .read<EmployeBloc>()
                              .add(DeleteData(int.parse(employee.id)));
                        },
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.grey.shade500,
                        icon: Icons.delete_rounded,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 10,
                          spreadRadius: 1,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        onTap: () {
                          editDataWidget(
                            context,
                            id: int.parse(employee.id),
                            fullName: employee.name,
                            jobs: employee.jobs,
                          );
                        },
                        borderRadius: BorderRadius.circular(8),
                        splashColor: Colors.grey.withOpacity(0.2),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    employee.name.toUpperCase(),
                                    style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                        color: Colors.grey.shade800,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Pekerjaan: ${employee.jobs}',
                                    style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
      // FLOATING ACTION BUTTON
      floatingActionButton: Material(
        color: Colors.green,
        shape: const CircleBorder(),
        elevation: 6,
        shadowColor: Colors.black.withOpacity(0.4),
        child: InkWell(
          onTap: () {
            addDataWidget(context);
          },
          customBorder: const CircleBorder(),
          splashColor: Colors.green.shade400,
          child: Container(
            height: 60,
            width: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }

  //ADD DATA
  void addDataWidget(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          surfaceTintColor: Colors.white,
          contentPadding: const EdgeInsets.all(0),
          content: Container(
            constraints: const BoxConstraints(maxWidth: 440, minWidth: 380),
            child: BlocBuilder<FieldBloc, FieldState>(
              builder: (context, stateField) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Tambah data',
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    //Name
                    fieldWidget(
                      context,
                      controller: fullController,
                      focusNode: focusNodeFullName,
                      label: 'FullName',
                      borderColor: stateField.hasFocus(KeyConstants.fullName)
                          ? Colors.green
                          : stateField.isNotEmpty(KeyConstants.fullName)
                              ? Colors.green.withOpacity(0.5)
                              : null,
                      borderWidth: stateField.hasFocus(KeyConstants.fullName)
                          ? 1.5
                          : null,
                      onChanged: (value) {
                        context.read<FieldBloc>().add(FieldIsNotEmptyEvent(
                            key: KeyConstants.fullName, text: value));
                      },
                    ),
                    //JOB
                    fieldWidget(
                      context,
                      controller: jobsController,
                      focusNode: focusNodeJobs,
                      label: 'Job',
                      borderColor: stateField.hasFocus(KeyConstants.jobs)
                          ? Colors.green
                          : stateField.isNotEmpty(KeyConstants.jobs)
                              ? Colors.green.withOpacity(0.5)
                              : null,
                      borderWidth:
                          stateField.hasFocus(KeyConstants.jobs) ? 1.5 : null,
                      onChanged: (value) {
                        context.read<FieldBloc>().add(FieldIsNotEmptyEvent(
                            key: KeyConstants.jobs, text: value));
                      },
                    ),
                    //BTN
                    Container(
                      margin: const EdgeInsets.only(
                          bottom: 20, left: 20, right: 20, top: 8),
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                            spreadRadius: 1,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          onTap: () {
                            if (fullController.text.isNotEmpty &&
                                jobsController.text.isNotEmpty) {
                              context.read<EmployeBloc>().add(AddData(
                                  name: fullController.text,
                                  jobs: jobsController.text));

                              fullController.clear();
                              jobsController.clear();

                              context.read<FieldBloc>().add(FieldResetEvent());
                              Navigator.pop(context);
                            }
                          },
                          borderRadius: BorderRadius.circular(8),
                          splashColor: Colors.white.withOpacity(0.2),
                          hoverColor: Colors.white.withOpacity(0.1),
                          child: Center(
                            child: Text(
                              'Tambah Data',
                              style: GoogleFonts.inter(
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  //EDIT DATA
  void editDataWidget(
    BuildContext context, {
    required int id,
    required String fullName,
    required String jobs,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        fullController.text = fullName;
        jobsController.text = jobs;
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          surfaceTintColor: Colors.white,
          contentPadding: const EdgeInsets.all(0),
          content: Container(
            constraints: const BoxConstraints(maxWidth: 440, minWidth: 380),
            child: BlocBuilder<FieldBloc, FieldState>(
              builder: (context, stateField) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Edit data',
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    //Name
                    fieldWidget(
                      context,
                      controller: fullController,
                      focusNode: focusNodeFullName,
                      label: 'FullName',
                      borderColor: stateField.hasFocus(KeyConstants.fullName)
                          ? Colors.green
                          : stateField.isNotEmpty(KeyConstants.fullName)
                              ? Colors.green.withOpacity(0.5)
                              : null,
                      borderWidth: stateField.hasFocus(KeyConstants.fullName)
                          ? 1.5
                          : null,
                      onChanged: (value) {
                        context.read<FieldBloc>().add(FieldIsNotEmptyEvent(
                            key: KeyConstants.fullName, text: value));
                      },
                    ),
                    //JOB
                    fieldWidget(
                      context,
                      controller: jobsController,
                      focusNode: focusNodeJobs,
                      label: 'Job',
                      borderColor: stateField.hasFocus(KeyConstants.jobs)
                          ? Colors.green
                          : stateField.isNotEmpty(KeyConstants.jobs)
                              ? Colors.green.withOpacity(0.5)
                              : null,
                      borderWidth:
                          stateField.hasFocus(KeyConstants.jobs) ? 1.5 : null,
                      onChanged: (value) {
                        context.read<FieldBloc>().add(FieldIsNotEmptyEvent(
                            key: KeyConstants.jobs, text: value));
                      },
                    ),
                    //BTN
                    Container(
                      margin: const EdgeInsets.only(
                          bottom: 20, left: 20, right: 20, top: 8),
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                            spreadRadius: 1,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          onTap: () {
                            context.read<EmployeBloc>().add(
                                  UpdateData(
                                    index: id,
                                    name: fullController.text,
                                    jobs: jobsController.text,
                                  ),
                                );

                            fullController.clear();
                            jobsController.clear();

                            context.read<FieldBloc>().add(FieldResetEvent());

                            Navigator.pop(context);
                          },
                          borderRadius: BorderRadius.circular(8),
                          splashColor: Colors.white.withOpacity(0.2),
                          hoverColor: Colors.white.withOpacity(0.1),
                          child: Center(
                            child: Text(
                              'Edit Data',
                              style: GoogleFonts.inter(
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  //MARK: FIELD WIDGET
  Widget fieldWidget(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    Function(String)? onChanged,
    Color? borderColor,
    double? borderWidth,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
      padding: const EdgeInsets.only(left: 12),
      height: 52,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor ?? Colors.grey.shade200,
          width: borderWidth ?? 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        cursorHeight: 16,
        cursorWidth: 1.5,
        obscuringCharacter: '●',
        onChanged: onChanged,
        autocorrect: false,
        style: GoogleFonts.inter(
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xff111827),
          ),
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(bottom: 13, top: 8),
          label: Text(
            label,
            style: GoogleFonts.inter(
              textStyle: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
