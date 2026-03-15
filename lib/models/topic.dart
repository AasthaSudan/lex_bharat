import 'package:flutter/material.dart';

class Topic {
  final String id;
  final String title;
  final String category;
  final String content;
  final String duration;
  final IconData icon;
  final Color color;

  Topic({
    required this.id,
    required this.title,
    required this.category,
    required this.content,
    required this.duration,
    required this.icon,
    required this.color,
  });

  factory Topic.fromJson(Map<String, dynamic> json) => Topic(
    id: json['id'],
    title: json['title'],
    category: json['category'],
    content: json['content'],
    duration: json['duration'],
    icon: Icons.article,
    color: Colors.blue,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'content': content,
    'duration': duration,
  };
}