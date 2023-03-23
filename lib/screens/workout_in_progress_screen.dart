import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_studt_app/bloc/workouts_cubit.dart';
import 'package:flutter_studt_app/helpers/shared.dart';
import 'package:flutter_studt_app/model/exercise.dart';
import 'package:flutter_studt_app/model/workout.dart';
import 'package:flutter_studt_app/states/workout_states.dart';
import '../bloc/workout_cubit.dart';

class WorkoutInProgressScreen extends StatelessWidget {
  const WorkoutInProgressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> getStats(Workout workout, int workoutElapsed) {
      int workoutTotal = workout.getTotal;
      Exercise exercise = workout.getCurrentExercise(workoutElapsed);
      int exerciseElapsed = workoutElapsed - exercise.startTime!;
      int exerciseRemaining = exercise.prelude! - exerciseElapsed;
      bool isPrelude = exerciseElapsed < exercise.prelude!;
      int exerciseTotal = isPrelude ? exercise.prelude! : exercise.duration!;
      if (!isPrelude) {
        exerciseElapsed -= exercise.prelude!;
        exerciseRemaining += exercise.duration!;
      }
      return {
        "workoutTitle": workout.title,
        "workoutProgress": workoutElapsed / workoutTotal,
        "exerciseProgress": exerciseElapsed / exerciseTotal,
        "workoutElapsed": workoutElapsed,
        "totalExercise": workout.exercisesList.length,
        "currentExerciseIndex": exercise.index!.toDouble(),
        "workoutRemaining": workoutTotal - workoutElapsed,
        "exerciseRemaining": exerciseRemaining,
        "isPrelude": isPrelude,
        "currentExercise" : exercise.title,
        "goToNext" : exercise.index!.toDouble() +1.toDouble(),
      };
    }

    return BlocConsumer<WorkoutCubit, WorkoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final stats = getStats(state.workout!, state.elapsed!);
        return Scaffold(
            appBar: AppBar(
              leading: BackButton(
                onPressed: () =>
                    BlocProvider.of<WorkoutCubit>(context).goHome(),
              ),
              title: Text(state.workout!.title!),
            ),
            body: Container(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  LinearProgressIndicator(
                    backgroundColor: Colors.blue[100],
                    minHeight: 10,
                    value: stats['workoutProgress'],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(formatTime(stats['workoutElapsed'], true)),
                        DotsIndicator(
                          dotsCount: stats['totalExercise'],
                          position: stats['currentExerciseIndex'],
                        ),
                        Text(
                            '- ${formatTime(stats["workoutRemaining"], true)}'),
                      ],
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    highlightColor: Colors.white10,
                    onTap: () {
                      if(state is WorkoutInProgressState){
                        BlocProvider.of<WorkoutCubit>(context)
                            .pauseWorkout();
                      }
                      else if(state is WorkoutPausedState){
                        BlocProvider.of<WorkoutCubit>(context)
                            .resume();
                      }
                    },
                    child: Stack(
                      alignment: const Alignment(0, 0.35),
                      children: [
                        Center(
                          child: SizedBox(
                            height: 220,
                            width: 220,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                stats['isPrelude'] ? Colors.red : Colors.blue,
                              ),
                              strokeWidth: 25,
                              value: stats['exerciseProgress'],
                            ),
                          ),
                        ),
                        Center(
                          child: SizedBox(
                            height: 400,
                            width: 300,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Image.asset('assets/images/stopwatch.png'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: (){

                    },
                    child: Text('--> ${stats["currentExercise"]}--',style: const TextStyle(fontSize: 30),),
                  )
                ],
              ),
            ));
      },
    );
  }
}
