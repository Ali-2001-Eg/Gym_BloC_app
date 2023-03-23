import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_studt_app/bloc/workout_cubit.dart';
import 'package:flutter_studt_app/bloc/workouts_cubit.dart';
import 'package:flutter_studt_app/model/workout.dart';
import 'package:flutter_studt_app/screens/edit_workout_screen.dart';
import 'package:flutter_studt_app/screens/home_screen.dart';
import 'package:flutter_studt_app/screens/workout_in_progress_screen.dart';
import 'package:flutter_studt_app/states/workout_states.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory());
  HydratedBlocOverrides.runZoned(
    () => runApp(const MyApp()),
    storage: storage,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyText2: TextStyle(color: Color.fromARGB(255, 66, 74, 96)),
        ),
        primarySwatch: Colors.blue,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<WorkoutsCubit>(
            create: (BuildContext context) => WorkoutsCubit()..getWorkouts(),
          ),
          BlocProvider<WorkoutCubit>(
            create: (context) => WorkoutCubit(),
          ),
        ],
        child: BlocBuilder<WorkoutCubit, WorkoutStates>(
          builder: (context, state) {
            if (state is WorkoutInitialState) {
              return const HomeScreen();
            } else if (state is WorkoutEditingState) {
              return const EditWorkoutScreen();
            }
            return const WorkoutInProgressScreen();
          },
        ),
      ),
    );
  }
}
