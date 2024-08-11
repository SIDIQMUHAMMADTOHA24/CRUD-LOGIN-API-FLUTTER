import 'package:bloc/bloc.dart';
import 'package:crud_interview/models/user_model.dart';
import 'package:crud_interview/services/auth_service.dart';
import 'package:equatable/equatable.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(UserLoading());
      try {
        Map<String, dynamic> data =
            await AuthService.login(event.phone, event.pin);

        if (data.containsKey('message')) {
          emit(UserFailure(data['message'].toString()));
        } else {
          // Emit UserLoggedIn jika login berhasil
          emit(UserLoggedIn());
        }
      } catch (e) {
        emit(UserFailure(e.toString()));
      }
    });

    on<RegisterEvent>((event, emit) async {
      emit(UserLoading());
      try {
        Map<String, dynamic> data = await AuthService.register(
            fullName: event.fullName, phone: event.phone, pin: event.pin);

        if (data.containsKey('message')) {
          emit(UserFailure(data['message'].toString()));
        } else {
          emit(UserLoggedIn());
        }
      } catch (e) {
        emit(UserFailure(e.toString()));
      }
    });

    on<GetUserEvent>((event, emit) async {
      try {
        emit(UserLoading());
        final userResponse = await AuthService.getUser();

        emit(UserSuccess(userModel: userResponse));
      } catch (e) {
        emit(UserFailure(e.toString()));
      }
    });
  }
}
