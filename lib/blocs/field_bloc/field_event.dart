part of 'field_bloc.dart';


sealed class FieldEvent extends Equatable {
  const FieldEvent();

  @override
  List<Object> get props => [];
}

class FieldFocusEvent extends FieldEvent {
  final KeyConstants key;
  final bool hasFocus;

  const FieldFocusEvent({required this.key, required this.hasFocus});

  @override
  List<Object> get props => [key, hasFocus];
}

class FieldIsNotEmptyEvent extends FieldEvent {
  final KeyConstants key;
  final String text;

  const FieldIsNotEmptyEvent({required this.key, required this.text});

  @override
  List<Object> get props => [key, text];
}

class PasswordVisibilityToggled extends FieldEvent {
  final KeyConstants key;

  const PasswordVisibilityToggled({required this.key});

  @override
  List<Object> get props => [key];
}

class FieldResetEvent extends FieldEvent {}
