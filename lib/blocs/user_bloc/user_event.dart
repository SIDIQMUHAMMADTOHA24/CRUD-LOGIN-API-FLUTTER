part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends UserEvent {
  final String phone;
  final String pin;

  const LoginEvent({required this.phone, required this.pin});

  @override
  List<Object> get props => [phone, pin];
}

class RegisterEvent extends UserEvent {
  final String fullName;
  final String phone;
  final String pin;

  const RegisterEvent(
      {required this.fullName, required this.phone, required this.pin});

  @override
  List<Object> get props => [fullName, phone, pin];
}

class GetUserEvent extends UserEvent {}
