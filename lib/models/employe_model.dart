import 'dart:convert';

List<EmployeModel> karyawanFromJson(String str) =>
    List<EmployeModel>.from(json.decode(str).map((x) => EmployeModel.fromJson(x)));

String karyawanToJson(List<EmployeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EmployeModel {
  String name;
  String jobs;
  String id;

  EmployeModel({
    required this.name,
    required this.jobs,
    required this.id,
  });

  EmployeModel copyWith({
    String? name,
    String? jobs,
    String? id,
  }) =>
      EmployeModel(
        name: name ?? this.name,
        jobs: jobs ?? this.jobs,
        id: id ?? this.id,
      );

  factory EmployeModel.fromJson(Map<String, dynamic> json) => EmployeModel(
        name: json["name"],
        jobs: json["jobs"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "jobs": jobs,
        "id": id,
      };

  @override
  String toString() => 'Karyawan(name: $name, jobs: $jobs, id: $id)';
}
