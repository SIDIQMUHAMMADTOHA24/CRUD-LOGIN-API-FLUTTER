part of 'image_bloc.dart';

sealed class ImageEvent extends Equatable {
  const ImageEvent();

  @override
  List<Object> get props => [];
}

class PickImageEvent extends ImageEvent {
  final ImageSource source;

  const PickImageEvent({required this.source});

  @override
  List<Object> get props => [source];
}

class RemoveImageEvent extends ImageEvent {}
