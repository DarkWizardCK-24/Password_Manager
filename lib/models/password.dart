import 'package:equatable/equatable.dart';

class PasswordModel extends Equatable {
  final String id;
  final String username;
  final String password;
  final String socialMedia;
  final String link;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const PasswordModel({
    required this.id,
    required this.username,
    required this.password,
    required this.socialMedia,
    required this.link,
    required this.createdAt,
    this.updatedAt,
  });

  factory PasswordModel.fromJson(Map<String, dynamic> json) {
    return PasswordModel(
      id: json['id'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      socialMedia: json['socialMedia'] as String,
      link: json['link'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'socialMedia': socialMedia,
      'link': link,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  PasswordModel copyWith({
    String? id,
    String? username,
    String? password,
    String? socialMedia,
    String? link,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PasswordModel(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      socialMedia: socialMedia ?? this.socialMedia,
      link: link ?? this.link,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        username,
        password,
        socialMedia,
        link,
        createdAt,
        updatedAt,
      ];
}