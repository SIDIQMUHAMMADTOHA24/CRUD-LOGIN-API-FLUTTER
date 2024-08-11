import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

part 'image_event.dart';
part 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  ImageBloc() : super(ImageInitial()) {
    final ImagePicker _picker = ImagePicker();
    on<PickImageEvent>((event, emit) async {
      emit(ImageLoading());
      try {
        final XFile? pickedFile = await _picker.pickImage(source: event.source);
        emit(ImageSuccess(imageFile: File(pickedFile!.path)));
      } catch (e) {
        emit(ImageFailure());
      }
    });

    on<RemoveImageEvent>((event, emit) {
      emit(ImageLoading());
      emit(const ImageSuccess(imageFile: null));
    });
  }
}
