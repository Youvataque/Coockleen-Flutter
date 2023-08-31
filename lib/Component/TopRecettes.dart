import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// ignore: must_be_immutable
class TopRecettes extends StatefulWidget {
  int typedit;
  Image picturecomp;
  final VoidCallback onModifierPressed;
  TopRecettes({
    Key? key,
    required this.typedit,
    required this.picturecomp,
    required this.onModifierPressed,
  });
  @override
  State<TopRecettes> createState() => _TopRecettesState();
}

class _TopRecettesState extends State<TopRecettes> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 225,
      pinned: true,
      elevation: 0,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        background: widget.picturecomp,
        stretchModes: [StretchMode.blurBackground, StretchMode.zoomBackground],
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(0.0),
        child: Container(
          alignment: Alignment.center,
          height: 32,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32), topRight: Radius.circular(32))),
          child: Container(
            height: 5,
            width: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Color(0xFFECECEC),
            ),
          ),
        ),
      ),
      leading: Padding(
        padding: EdgeInsets.only(left: 10),
        child: InkWell(
            onTap: () {},
            child: Container(
              height: 56.0,
              width: 56.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.withOpacity(0.20),
              ),
              child: Icon(CupertinoIcons.arrow_left),
            )),
      ),
      actions: [
        if (widget.typedit == 0)
          Container(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: widget.onModifierPressed,
              child: Text("Modifier"),
            ),
          )
      ],
    );
  }
}
