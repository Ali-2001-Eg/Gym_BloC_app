import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_studt_app/bloc/workout_cubit.dart';
import 'package:flutter_studt_app/bloc/workouts_cubit.dart';
import 'package:flutter_studt_app/helpers/shared.dart';
import 'package:flutter_studt_app/model/workout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Workout Time!'),
          actions: const [
            IconButton(onPressed: null, icon: Icon(Icons.event_available)),
            IconButton(onPressed: null, icon: Icon(Icons.settings)),
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: BlocBuilder<WorkoutsCubit, List<Workout>>(
            builder: (context, workouts) => ExpansionPanelList.radio(
              children: workouts
                  .map(
                    (e) => ExpansionPanelRadio(
                      value: e,
                      headerBuilder: (context, isExpanded) => ListTile(
                        visualDensity: const VisualDensity(
                          horizontal: 0,
                          vertical: VisualDensity.maximumDensity,
                        ),
                        onTap: () => !isExpanded
                            ? BlocProvider.of<WorkoutCubit>(context)
                                .startWorkout(e)
                            : null,
                        leading: IconButton(
                            onPressed: () =>
                                BlocProvider.of<WorkoutCubit>(context)
                                    .editWorkout(e, workouts.indexOf(e)),
                            icon: const Icon(Icons.edit)),
                        title: Text(e.title!),
                        trailing: Text(formatTime(e.getTotal, true)),
                      ),
                      body: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: e.exercisesList.length,
                        itemBuilder: (context, index) => ListTile(
                          visualDensity: const VisualDensity(
                            horizontal: 0,
                            vertical: VisualDensity.maximumDensity,
                          ),
                          leading: Text(formatTime(
                              e.exercisesList[index].prelude!, true)),
                          title: Text(e.exercisesList[index].title!),
                          trailing: Text(formatTime(
                              e.exercisesList[index].duration!, true)),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
