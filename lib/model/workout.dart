import 'package:equatable/equatable.dart';
import 'package:flutter_studt_app/model/exercise.dart';

class Workout extends Equatable {
  final String? title;
  final List<Exercise> exercisesList;

  const Workout({
    this.title,
    required this.exercisesList,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    List<Exercise> exercises = [];

    int index = 0;
    int startTime = 0;
    for (var ex in (json['exercises'] as Iterable)) {
      exercises.add(Exercise.fromJson(ex, index, startTime));
      index++;
      // print(index);
      //to calculate when new game is played
      startTime += exercises.last.prelude! + exercises.last.duration!;
    }

    return Workout(
      title: json["title"] as String?,
      exercisesList: exercises,
    );
  }

  //fold is like reduce method but it can sum selected items in the object not all keys of it
  int get getTotal => exercisesList.fold(
      0,
      (previousValue, element) =>
          previousValue + element.duration! + element.prelude!);

  Map<String, dynamic> toJson() => {
        'title': title,
        'exercises': exercisesList,
      };

  //to save the new title
  Workout copyWith({
    String? title,
  }) =>
      Workout(
        title: title ?? this.title,
        exercisesList: exercisesList,
      );

  Exercise getCurrentExercise(int? elapsed) =>
      exercisesList.lastWhere((element) => element.startTime! <= elapsed!);

  @override
  List<Object?> get props => [title, exercisesList];

  @override
  bool get stringify => true;
}
