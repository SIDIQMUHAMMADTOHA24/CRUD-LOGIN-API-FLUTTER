//MARK: - POP UP
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

void popUpInfoWidget(
  BuildContext context, {
  bool isSuccess = true,
  required String title,
  required String description,
  required String btnLabel,
  Function()? onTap,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        surfaceTintColor: Colors.white,
        contentPadding: const EdgeInsets.all(0),
        content: Container(
          constraints: const BoxConstraints(maxWidth: 440, minWidth: 380),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Spacer(),
                  IconButton(
                      onPressed: onTap,
                      icon: Icon(
                        Icons.close,
                        color: Colors.grey.shade400,
                        size: 24,
                      ))
                ],
              ),
              const SizedBox(height: 40),

              SizedBox(
                  width: 100,
                  height: 100,
                  child: SvgPicture.asset(
                    isSuccess
                        ? 'assets/svg/succes-icon.svg'
                        : 'assets/svg/failed-icon.svg',
                    fit: BoxFit.cover,
                  )),

              const SizedBox(height: 30),

              Text(
                title,
                style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: GoogleFonts.inter(
                  textStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  color: Colors.grey.shade200,
                ),
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
                  color: isSuccess ? Colors.green : Colors.orange.shade600,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(8),
                    splashColor: Colors.white.withOpacity(0.2),
                    hoverColor: Colors.white.withOpacity(0.1),
                    child: Center(
                      child: Text(
                        btnLabel,
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
          ),
        ),
      );
    },
  );
}
