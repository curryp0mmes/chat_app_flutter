import 'package:flutter/material.dart';
import 'package:mkship_app/constants.dart';
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
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(child: data.picture, borderRadius: BorderRadius.circular(10)),
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(data.name == null ? "" : data.name! + (data.age == null ? "" : ", "), style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),),
                Text(data.age == null ? "" : data.age.toString(), style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),),
              ],
            )
          ),
        ],
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
    var _cardWidth = MediaQuery.of(context).size.width - Constants.edgePadding * 2;
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
              child: Container(child: _getFullCard(person), width: _cardWidth, height: _cardWidth,)
          );
        }
      ),
      child: _getFullCard(person),
    );
  }
}
