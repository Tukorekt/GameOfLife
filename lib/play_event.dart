part of 'play_bloc.dart';

@immutable
abstract class PlayEvent {}

class PlayingEvent extends PlayEvent{
  final List<bool> points;
  final List<List<int>> steps ;
  final List<int> listPoints;
  PlayingEvent({required this.points, required this.steps, required this.listPoints});
}


