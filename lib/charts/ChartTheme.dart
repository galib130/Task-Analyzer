import 'package:charts_flutter/flutter.dart';

import 'package:charts_flutter/flutter.dart' as charts;

class Barchart {
  OrdinalAxisSpec GetOrdinalAxisSpec() {
    return charts.OrdinalAxisSpec(
        renderSpec: new charts.SmallTickRendererSpec(
      labelStyle: new charts.TextStyleSpec(
          fontSize: 18, // size in Pts.
          color: charts.MaterialPalette.blue.shadeDefault),
    ));
  }

  NumericAxisSpec GetNumericAxisSpec() {
    return charts.NumericAxisSpec(
        renderSpec: new charts.SmallTickRendererSpec(
      labelStyle: new charts.TextStyleSpec(
        fontSize: 18,
        color: charts.MaterialPalette.blue.shadeDefault,
      ),
    ));
  }
}
