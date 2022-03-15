import 'package:flutter/material.dart';
import 'package:mkship_app/constants.dart';
import 'package:rxdart/rxdart.dart';

class CardData {
  String? name;
  int? age;
  var picture;
  CardData({required this.picture, this.name, this.age});
}

class DraggableCard extends StatefulWidget {
  CardData personData;

  DraggableScrollableController? controller;

  Function onLike;
  Function onDislike;

  DraggableCard({Key? key, required this.personData, required this.onLike, required this.onDislike}) : super(key: key);

  @override
  State<DraggableCard> createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard> {
  get person => widget.personData;
  BehaviorSubject<double> _rotationStream = BehaviorSubject<double>();

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
      childWhenDragging: Container(),
      feedback: StreamBuilder(
        stream: _rotationStream,
        builder: (context, snapshot) {
          return Transform.rotate(angle: _rotationStream.value, filterQuality: FilterQuality.high,
              child: SizedBox(child: ProfileSwipingCard(personData: person, elevation: 20,), width: _cardWidth, height: _cardWidth,)
          );
        }
      ),
      child: ProfileSwipingCard(personData: person,elevation: 0,),
    );
  }
}


class ProfileSwipingCard extends StatefulWidget {
  final CardData personData;
  final double elevation;
  const ProfileSwipingCard({Key? key, required this.personData, this.elevation = 12}) : super(key: key);

  @override
  State<ProfileSwipingCard> createState() => _ProfileSwipingCardState();
}

class _ProfileSwipingCardState extends State<ProfileSwipingCard> {
  CardData get personData => widget.personData;
  double get elevation => widget.elevation;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(child: personData.picture, borderRadius: BorderRadius.circular(10)),
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
                  Text(personData.name == null ? "" : personData.name! + (personData.age == null ? "" : ", "), style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),),
                  Text(personData.age == null ? "" : personData.age.toString(), style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),),
                ],
              )
          ),
        ],
      ),
    );
  }
}
