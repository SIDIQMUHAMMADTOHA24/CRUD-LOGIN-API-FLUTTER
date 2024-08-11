part of 'employe_bloc.dart';

sealed class EmployeEvent extends Equatable {
  const EmployeEvent();

  @override
  List<Object> get props => [];
}

class GetData extends EmployeEvent {}

class AddData extends EmployeEvent {
  final String name;
  final String jobs;

  const AddData({required this.name, required this.jobs});

  @override
  List<Object> get props => [name, jobs];
}

class UpdateData extends EmployeEvent {
  final int index;
  final String name;
  final String jobs;

  const UpdateData(
      {required this.index, required this.name, required this.jobs});

  @override
  List<Object> get props => [name, jobs, index];
}

class DeleteData extends EmployeEvent {
  final int index;

  const DeleteData(this.index);
  @override
  List<Object> get props => [index];
}
