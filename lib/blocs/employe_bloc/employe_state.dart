part of 'employe_bloc.dart';

sealed class EmployeState extends Equatable {
  const EmployeState();

  @override
  List<Object> get props => [];
}

final class EmployeInitial extends EmployeState {}

class EmployeSuccess extends EmployeState {
  final List<EmployeModel> listDataTodo;

  const EmployeSuccess(this.listDataTodo);
  @override
  List<Object> get props => [listDataTodo];
}

class EmployeFailure extends EmployeState {}
