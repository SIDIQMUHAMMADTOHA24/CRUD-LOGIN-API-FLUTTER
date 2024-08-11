import 'package:crud_interview/blocs/field_bloc/field_bloc.dart';
import 'package:crud_interview/blocs/user_bloc/user_bloc.dart';
import 'package:crud_interview/utils/image_utils.dart';
import 'package:crud_interview/utils/key_constant.dart';
import 'package:crud_interview/views/home_view.dart';
import 'package:crud_interview/views/register_view.dart';
import 'package:crud_interview/views/widget/code_picker_widget.dart';
import 'package:crud_interview/views/widget/pop_up_info_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  final FocusNode focusNodePhone = FocusNode();
  final FocusNode focusNodePin = FocusNode();

  @override
  void initState() {
    super.initState();
    context.read<FieldBloc>().add(FieldResetEvent());

    addFocusListener(KeyConstants.phone, focusNodePhone);
    addFocusListener(KeyConstants.pin, focusNodePin);
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
    phoneController.dispose();
    pinController.dispose();
    focusNodePhone.dispose();
    focusNodePin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //BODY
      body: BlocBuilder<FieldBloc, FieldState>(
        builder: (context, stateField) {
          return ListView(
            padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: MediaQuery.paddingOf(context).top + 20),
            children: [
              Text(
                'Hola! Selamat datang di Employe.',
                style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                'Mohon masukkan nomor telepon Anda untuk melanjutkan',
                style: GoogleFonts.inter(
                  textStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 14,
                    height: 1.2,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              //NOMOR HP FIELD
              fieldWidget(
                context,
                isPhoneNumber: true,
                controller: phoneController,
                focusNode: focusNodePhone,
                label: 'Phone Number',
                borderColor: stateField.hasFocus(KeyConstants.phone)
                    ? Colors.green
                    : stateField.isNotEmpty(KeyConstants.phone)
                        ? Colors.green.withOpacity(0.5)
                        : null,
                borderWidth:
                    stateField.hasFocus(KeyConstants.phone) ? 1.5 : null,
                onChanged: (value) {
                  context.read<FieldBloc>().add(FieldIsNotEmptyEvent(
                      key: KeyConstants.phone, text: value));
                },
              ),

              const SizedBox(height: 16),

              //PIN FIELD
              fieldWidget(
                context,
                controller: pinController,
                focusNode: focusNodePin,
                label: 'Password',
                borderColor: stateField.hasFocus(KeyConstants.pin)
                    ? Colors.green
                    : stateField.isNotEmpty(KeyConstants.pin)
                        ? Colors.green.withOpacity(0.5)
                        : null,
                borderWidth: stateField.hasFocus(KeyConstants.pin) ? 1.5 : null,
                onChanged: (value) {
                  context.read<FieldBloc>().add(
                      FieldIsNotEmptyEvent(key: KeyConstants.pin, text: value));
                },
              ),

              //BUTTON LOGIN
              BlocConsumer<UserBloc, UserState>(
                listener: (context, stateUser) {
                  if (stateUser is UserLoggedIn) {
                    popUpInfoWidget(
                      context,
                      title: 'Login Berhasil!',
                      description: 'Selamat, login Anda berhasil!',
                      btnLabel: 'Tutup',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeView()));
                      },
                    );
                  } else if (stateUser is UserFailure) {
                    popUpInfoWidget(
                      context,
                      isSuccess: false,
                      title: 'Login Gagal!',
                      description: stateUser.error,
                      btnLabel: 'Coba Lagi',
                      onTap: () {
                        Navigator.pop(context);
                      },
                    );
                  }
                },
                builder: (context, stateUser) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Material(
                      color: (stateField.isNotEmpty(KeyConstants.pin) &&
                              stateField.isNotEmpty(KeyConstants.phone))
                          ? Colors.green
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () {
                          if (phoneController.text.isNotEmpty &&
                              pinController.text.isNotEmpty) {
                            context.read<UserBloc>().add(LoginEvent(
                                  phone: phoneController.text.trim(),
                                  pin: pinController.text.trim(),
                                ));
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        splashColor: Colors.white.withOpacity(0.2),
                        hoverColor: Colors.white.withOpacity(0.1),
                        child: Center(
                          child: (stateUser is UserLoading)
                              ? const SizedBox(
                                  width: 27,
                                  height: 27,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  'Login',
                                  style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                      color: (stateField.isNotEmpty(
                                                  KeyConstants.pin) &&
                                              stateField.isNotEmpty(
                                                  KeyConstants.phone))
                                          ? Colors.white
                                          : Colors.grey.shade400,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),

      //BOTTOM SHEET
      bottomSheet: Container(
        color: Colors.white,
        padding:
            EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom + 20),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'Belum punya akun? ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade500,
            ),
            children: [
              TextSpan(
                text: 'Buat akun disini',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterView()));
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }

  //MARK: FIELD WIDGET
  Widget fieldWidget(
    BuildContext context, {
    bool isPhoneNumber = false,
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    Function(String)? onChanged,
    Color? borderColor,
    double? borderWidth,
  }) {
    return Row(
      children: [
        isPhoneNumber
            ? Container(
                margin: const EdgeInsets.only(right: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: CodePickerWidget(
                  initialSelection: 'ID',
                  flagWidth: 20,
                  enabled: false,
                  textStyle: GoogleFonts.inter(
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff111827),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 12),
            height: 52,
            decoration: BoxDecoration(
              border: Border.all(
                color: borderColor ?? Colors.grey.shade200,
                width: borderWidth ?? 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    cursorHeight: 16,
                    cursorWidth: 1.5,
                    obscuringCharacter: '●',
                    obscureText: !isPhoneNumber
                        ? context
                            .read<FieldBloc>()
                            .state
                            .isVisible(KeyConstants.pin)
                        : false,
                    onChanged: onChanged,
                    keyboardType: isPhoneNumber
                        ? TextInputType.phone
                        : TextInputType.text,
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
                ),

                //BTN OBSCURE
                !isPhoneNumber
                    ? GestureDetector(
                        onTap: () {
                          context.read<FieldBloc>().add(
                              const PasswordVisibilityToggled(
                                  key: KeyConstants.pin));
                        },
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.only(left: 10, right: 12),
                          color: Colors.transparent,
                          child: SvgPicture.asset(
                            context
                                    .read<FieldBloc>()
                                    .state
                                    .isVisible(KeyConstants.pin)
                                ? ImageUtils.eyeSplashPNG
                                : ImageUtils.eyeIconPNG,
                            width: 20,
                            height: 20,
                            colorFilter: ColorFilter.mode(
                                Colors.grey.shade500, BlendMode.srcIn),
                          ),
                        ),
                      )
                    : const SizedBox()
              ],
            ),
          ),
        ),
      ],
    );
  }
}
