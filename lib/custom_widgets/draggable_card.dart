import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class DraggableCard extends StatefulWidget {
  CardData personData;
  CardData nextPersonData;

  DraggableScrollableController? controller;

  Function onLike;
  Function onDislike;

  DraggableCard({Key? key, required this.personData,  required this.nextPersonData, required this.onLike, required this.onDislike}) : super(key: key);

  @override
  State<DraggableCard> createState() => _DraggableCardState();
}

class CardData {
  String? name;
  int? age;
  var picture;
  CardData({required this.picture, this.name, this.age});
}

class _DraggableCardState extends State<DraggableCard> {
  get person => widget.personData;
  get nextPerson => widget.nextPersonData;
  BehaviorSubject<double> _rotationStream = BehaviorSubject<double>();

  Card _getFullCard(CardData data) {
    return Card(
      elevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: data.picture,
                fit: BoxFit.cover,
              )
          ),
          alignment: Alignment.bottomRight,
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(data.name == null ? "" : data.name! + ", ", style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),),
              Text(data.age == null ? "" : data.age.toString(), style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),),
            ],
          )
      ),
    );
  }

  @override
  void initState() {
    _rotationStream = BehaviorSubject<double>();
    _rotationStream.add(0.0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _deviceWidth = MediaQuery.of(context).size.width;
    var likeThreshhold = 0.10;

    return Draggable(
      onDragUpdate: (data) {
        setState(() {
          _rotationStream.value += data.delta.dx * 0.001;
        });
      },
      onDragEnd: (data) {
        if(_rotationStream.value > likeThreshhold) {
          widget.onLike();
        } else if(_rotationStream.value < -likeThreshhold) {
          widget.onDislike();
        }
        _rotationStream.value = 0.0;
      },
      affinity: Axis.horizontal,
      axis: Axis.horizontal,
      childWhenDragging: _getFullCard(nextPerson),
      feedback: StreamBuilder(
        stream: _rotationStream,
        builder: (context, snapshot) {
          return Transform.rotate(angle: _rotationStream.value, filterQuality: FilterQuality.high,
              child: Container(child: _getFullCard(person), width: _deviceWidth, height: _deviceWidth,)
          );
        }
      ),
      child: _getFullCard(person),
    );
  }
}
