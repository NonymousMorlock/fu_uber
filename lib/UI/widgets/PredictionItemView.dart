import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';

class PredictionItemView extends StatelessWidget {
  final Prediction prediction;

  const PredictionItemView({super.key, required this.prediction});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(prediction.description ?? "Unknown"),
        trailing: Icon(Icons.arrow_forward),
      ),
    );
  }
}
