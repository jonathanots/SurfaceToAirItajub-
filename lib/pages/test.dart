import 'package:flutter/material.dart';
import 'package:surfaceair/repository/measures.dart';

class MeasuresPage extends StatefulWidget {
  @override
  _MeasuresPageState createState() => _MeasuresPageState();
}

class _MeasuresPageState extends State<MeasuresPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Measures measure = Measures();
    measure.getMeasures();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple,
    );
  }
}