part of 'play_bloc.dart';

@immutable
abstract class PlayState {}

class PlayInitial extends PlayState {}

class PlayGetState extends PlayState {
  final bool playing;
  final int code;
  final List<bool> points;
  final List<int> pointsFilled;
  final List<List<int>> steps ;
  final List<int> listPoints;
  PlayGetState({required this.code, required this.points, required this.pointsFilled, required this.steps, required this.listPoints, required this.playing});
}


