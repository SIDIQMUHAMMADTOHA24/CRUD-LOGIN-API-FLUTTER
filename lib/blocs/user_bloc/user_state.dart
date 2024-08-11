part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

final class UserInitial extends UserState {}

final class UserLoading extends UserState {}

final class UserLoggedIn extends UserState {}

final class UserSuccess extends UserState {
  final UserModel? userModel;

  const UserSuccess({this.userModel});

  @override
  List<Object> get props {
    List<Object> props = [];
    if (userModel != null) {
      props.add(userModel!);
    }
    return props;
  }
}

final class UserFailure extends UserState {
  final String error;

  const UserFailure(this.error);

  @override
  List<Object> get props => [error];
}
