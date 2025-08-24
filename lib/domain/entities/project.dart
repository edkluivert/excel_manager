import 'package:equatable/equatable.dart';

class Project extends Equatable {
  const Project({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  Project copyWith({String? name, DateTime? updatedAt}) => Project(
    id: id, name: name ?? this.name,
    createdAt: createdAt, updatedAt: updatedAt ?? this.updatedAt,
  );
  @override List<Object?> get props => [id, name, createdAt, updatedAt];
}
