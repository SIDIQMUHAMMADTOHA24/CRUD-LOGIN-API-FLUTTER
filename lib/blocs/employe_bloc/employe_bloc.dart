import 'package:bloc/bloc.dart';
import 'package:crud_interview/models/todo_model.dart';
import 'package:crud_interview/services/employe_service.dart';
import 'package:equatable/equatable.dart';

part 'employe_event.dart';
part 'employe_state.dart';

class EmployeBloc extends Bloc<EmployeEvent, EmployeState> {
  EmployeBloc() : super(EmployeInitial()) {
    //! Get Data
    on<GetData>((event, emit) async {
      try {
        List<EmployeModel> data = await EmployeServis().getData();
        emit(EmployeSuccess(data));
      } catch (e) {
        emit(EmployeFailure());
      }
    });

    //! Add Data
    on<AddData>((event, emit) async {
      try {
        List<EmployeModel> data =
            await EmployeServis().addData(event.name, event.jobs);
        emit(EmployeSuccess(data));
      } catch (e) {
        emit(EmployeFailure());
      }
    });

    //! Update Data
    on<UpdateData>((event, emit) async {
      try {
        List<EmployeModel> data = await EmployeServis().updateData(
          id: event.index,
          jobs: event.jobs,
          name: event.name,
        );
        emit(EmployeSuccess(data));
      } catch (e) {
        emit(EmployeFailure());
      }
    });

    //! Delete Data
    on<DeleteData>((event, emit) async {
      try {
        List<EmployeModel> data = await EmployeServis().deleteData(event.index);
        emit(EmployeSuccess(data));
      } catch (e) {
        emit(EmployeFailure());
      }
    });
  }
}
