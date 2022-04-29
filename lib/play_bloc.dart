
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'play_event.dart';

part 'play_state.dart';

class PlayBloc extends Bloc<PlayEvent, PlayState> {
  PlayBloc() : super(PlayInitial()) {
    on<PlayingEvent>((event, emit) {
      List<int> pointsFilled = [1];
      List<bool> points = event.points;
      List<List<int>> steps = event.steps;
      List<int> counters = [];
      for (var el in event.listPoints) {
        List<int> deadList = [
          el + 1,
          el - 1,
          el - 30,
          el + 30,
          el - 31,
          el - 29,
          el + 31,
          el + 29
        ];
        var counter = 0;
        if (el + 1 < 900 ? event.points[el + 1] : false) {
          counter++;
        }
        if (el - 1 >= 0 ? event.points[el - 1] : false) {
          counter++;
        }
        if (el - 30 >= 0 ? event.points[el - 30] : false) {
          counter++;
        }
        if (el + 30 < 900 ? event.points[el + 30] : false) {
          counter++;
        }
        if (el - 31 >= 0 ? event.points[el - 31] : false) {
          counter++;
        }
        if (el - 29 >= 0 ? event.points[el - 29] : false) {
          counter++;
        }
        if (el + 31 < 900 ? event.points[el + 31] : false) {
          counter++;
        }
        if (el + 29 < 900 ? event.points[el + 29] : false) {
          counter++;
        }
        counters.add(counter);
        switch (counter) {
          case 2:
            if (pointsFilled.contains(1)) {
              pointsFilled.remove(1);
            }
            if (!pointsFilled.contains(el)) {
              pointsFilled.add(el);
            }
            break;
          case 3:
            if (pointsFilled.contains(1)) {
              pointsFilled.remove(1);
            }
            if (!pointsFilled.contains(el)) {
              pointsFilled.add(el);
            }
            break;
        }
        for (var dead in deadList) {
          if (dead < 900 && dead >= 0 ? !event.points[dead] : false) {
            var counter = 0;
            if (dead + 1 < 900 ? event.points[dead + 1] : false) {
              counter++;
            }
            if (dead - 1 >= 0 ? event.points[dead - 1] : false) {
              counter++;
            }
            if (dead - 30 >= 0 ? event.points[dead - 30] : false) {
              counter++;
            }
            if (dead + 30 < 900 ? event.points[dead + 30] : false) {
              counter++;
            }
            if (dead - 31 >= 0 ? event.points[dead - 31] : false) {
              counter++;
            }
            if (dead - 29 >= 0 ? event.points[dead - 29] : false) {
              counter++;
            }
            if (dead + 31 < 900 ? event.points[dead + 31] : false) {
              counter++;
            }
            if (dead + 29 < 900 ? event.points[dead + 29] : false) {
              counter++;
            }
            counters.add(counter);
            switch (counter) {
              case 3:
                if (pointsFilled.contains(1)) {
                  pointsFilled.remove(1);
                }
                if (!pointsFilled.contains(dead)) {
                  pointsFilled.add(dead);
                }
                break;
            }
          }
        }
      }
      if (!event.points.any((element) => element)) {
        emit(PlayGetState(
            code: 0,
            points: event.points,
            pointsFilled: pointsFilled,
            steps: steps,
            listPoints: counters,
            playing: false));
      } else {
        if (pointsFilled.contains(1)) {
          emit(PlayGetState(
              code: 1,
              points: event.points,
              pointsFilled: pointsFilled,
              steps: steps,
              listPoints: counters,
              playing: true));
        } else {
          var a = true;
          for (var element in steps) {
            var c = 0;
            for (var element1 in element) {
              for (var search in pointsFilled) {
                if (element1 == search) {
                  c++;
                }
              }
            }
            if (c == pointsFilled.length) {
              a = false;
              emit(PlayGetState(
                  code: 2,
                  points: points,
                  pointsFilled: pointsFilled,
                  steps: steps,
                  listPoints: counters,
                  playing: true));
            }
          }
          if (a) {
            points = List.generate(30 * 30, (index) => false);
            for (var el in pointsFilled) {
              points[el] = true;
            }
            steps.add(pointsFilled);
            emit(PlayGetState(
                code: 0,
                points: points,
                pointsFilled: pointsFilled,
                steps: steps,
                listPoints: counters,
                playing: true));
          }
        }
      }
    });
  }
}
