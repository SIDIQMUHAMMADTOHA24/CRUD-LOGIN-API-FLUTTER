import 'package:bloc/bloc.dart';
import 'package:crud_interview/utils/key_constant.dart';
import 'package:equatable/equatable.dart';

part 'field_event.dart';
part 'field_state.dart';

class FieldBloc extends Bloc<FieldEvent, FieldState> {
  FieldBloc()
      : super(const FieldState(focusMap: {}, textMap: {}, visibilityMap: {})) {
    //HANDLE FOCUS NODE
    on<FieldFocusEvent>((event, emit) {
      final updatedFocusMap = Map<KeyConstants, bool>.from(state.focusMap)
        ..[event.key] = event.hasFocus;
      emit(FieldState(
        focusMap: updatedFocusMap,
        textMap: state.textMap,
        visibilityMap: state.visibilityMap,
      ));
    });

    //HANDLE FIELD IS NOT EMPTY
    on<FieldIsNotEmptyEvent>((event, emit) {
      final updatedTextMap = Map<KeyConstants, String>.from(state.textMap)
        ..[event.key] = event.text;
      emit(FieldState(
        focusMap: state.focusMap,
        textMap: updatedTextMap,
        visibilityMap: state.visibilityMap,
      ));
    });

    //HANDLE OBSCURE PASSWORD
    on<PasswordVisibilityToggled>((event, emit) {
      final updatedVisibilityMap =
          Map<KeyConstants, bool>.from(state.visibilityMap)
            ..[event.key] = !(state.visibilityMap[event.key] ?? false);
      emit(FieldState(
        focusMap: state.focusMap,
        textMap: state.textMap,
        visibilityMap: updatedVisibilityMap,
      ));
    });

    //HANDLE RESET STATE
    on<FieldResetEvent>((event, emit) {
      emit(const FieldState(focusMap: {}, textMap: {}, visibilityMap: {}));
    });
  }
}
