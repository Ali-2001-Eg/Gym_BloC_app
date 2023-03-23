import 'package:equatable/equatable.dart';

class Exercise extends Equatable {
  Exercise({
    required this.title,
    required this.prelude,
    required this.duration,
    this.index,
    this.startTime,
  });

  final String? title;
  final int? prelude;
  final int? duration;
   int? index;
  final int? startTime;

  factory Exercise.fromJson(
          Map<String, dynamic> json, int index, int startTime) =>
      Exercise(
        title: json["title"],
        prelude: json["prelude"],
        duration: json["duration"],
        index: index,
        startTime: startTime,
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "prelude": prelude,
        "duration": duration,
      };

  //copy wih to edit in the data
  Exercise copyWith({
    int? prelude,
    String? title,
    int? duration,
    int? index,
    int? startTime,
  }) =>
      Exercise(
        prelude: prelude ?? this.prelude,
        title: title ?? this.title,
        duration: duration ?? this.duration,
        startTime: startTime ?? this.startTime,
        index: index ?? this.index,
      );

  @override
  List<Object?> get props => [title, prelude, duration, index, startTime];
}
