import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifegame/play_bloc.dart';
void main(){
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
 runApp(
     MaterialApp(
       debugShowCheckedModeBanner: false,
       home: BlocProvider(
         create: (context) => PlayBloc(),
         child: const MainPage(),
       ),
     )
 );
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  List<bool> points = List.generate(30*30, (index)=>false);
  List<int> pointsFilled = [];
  List<List<int>> steps =[];
  var pause=false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool portrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return SafeArea(
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 235, 220, 178),
          body: BlocBuilder<PlayBloc,PlayState>(
          builder: (_,state){
            if (state is PlayGetState){
              if (state.playing){
                points = state.points;
                steps= state.steps;
                pointsFilled = state.pointsFilled;
              }
              return portrait ?
                 Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: widgets(size, state, portrait))
              :
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: widgets(size, state, portrait));
            } else {
                context.read<PlayBloc>().add(PlayingEvent(
                    points: points, steps: steps, listPoints: pointsFilled));
                return Container();
              }
          }),
        )
    );
  }

  List<Widget> widgets(Size size, PlayGetState state, bool portrait){
    return [
      SizedBox(
        width: (portrait) ? size.width : size.height ,
        height: (portrait) ? size.width : size.height ,
        child: Table(
          children: [
            for (var i = 0; i<30;i++)
              TableRow(
                  children: [
                    for (var j = 0; j< 30; j++)
                      GestureDetector(
                        onTap: (){
                          if (!state.playing){
                            if (!points[i*30+j]){
                              pointsFilled.add(i*30+j);
                            } else {
                              pointsFilled.remove(i*30+j);
                            }
                            setState(() {
                              points[i*30+j] = !points[i*30+j];
                            });
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.all(1),
                          width: (portrait) ? (size.width / 30) - 2 : (size.height / 30) - 2,
                          height: (portrait) ? (size.width / 30) - 2 : (size.height / 30) - 2,
                          color: (points[i*30+j]) ? const Color.fromARGB(255, 175, 68, 37) : const Color.fromARGB(255, 211, 176, 117),
                        ),
                      )
                  ]
              )
          ],
        ),
      ),
      GestureDetector(
        onTap: () async {
          if (state.playing){
            pause=true;
          }
          Timer.periodic(const Duration(seconds: 1), (timer){
            context.read<PlayBloc>().add(PlayingEvent(points: points, steps: steps, listPoints: pointsFilled));
            if (state.code > 0 || pause ){
              timer.cancel();
            }
          });
        },
        child: Container(
          width: (portrait) ? size.width / 2 : size.width / 5,
          height: (portrait) ? size.height / 15 : size.height / 8,
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 175, 68, 37),
              borderRadius: BorderRadius.circular(15)
          ),
          child: Center(
            child: Text(state.playing ? (pause ? 'Продолжить' : 'Пауза') : 'Играть',style: const TextStyle(color: Colors.white),),
          ),
        ),
      ),
      GestureDetector(
        onTap: () async {
            points = List.generate(30*30, (index) => false);
            steps = [];
            pointsFilled =[];
            pause=true;
          Timer.periodic(const Duration(seconds: 1), (timer){
            context.read<PlayBloc>().add(PlayingEvent(points: List.generate(30*30, (index) => false), steps: const [], listPoints: const []));
            if (state.code > 0 || pause){
              timer.cancel();
            }
          });
          await Future.delayed(const Duration(seconds: 1),(){});
            setState(() {});
            pause = false;
        },
        child: Container(
          width: (portrait) ? size.width / 3 : size.width / 6,
          height: (portrait) ? size.height / 20 : size.height / 10,
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 175, 68, 37),
              borderRadius: BorderRadius.circular(15)
          ),
          child: const Center(
            child: Text('Очистить',style: TextStyle(color: Colors.white),),
          ),
        ),
      )
    ];
  }

}