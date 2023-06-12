// // import 'package:flutter/material.dart';
// // import 'package:charts_flutter/flutter.dart' as charts;

// // class MyPieChart extends StatelessWidget {
// //   final List<charts.Series> seriesList;
// //   final bool? animate;

// //   MyPieChart(this.seriesList, { this.animate});

// //   @override
// //   Widget build(BuildContext context) {
// //     return new charts.PieChart(
// //       seriesList,
// //       animate: animate,
// //       defaultRenderer: new charts.ArcRendererConfig(
// //         arcRendererDecorators: [
// //           new charts.ArcLabelDecorator(
// //             labelPosition: charts.ArcLabelPosition.auto,
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // void main() {
// // //   runApp(new MaterialApp(
// // //     home: new Scaffold(
// // //       body: new Center(
// // //         child: new MyPieChart(
// // //           _createSampleData(),
// // //           animate: true,
// // //         ),
// // //       ),
// // //     ),
// // //   ));
// // // }

// //  List<charts.Series<MyData, String>> _createSampleData() {
// //   final data = [
// //     new MyData('Value 1', 30),
// //     new MyData('Value 2', 40),
// //     new MyData('Value 3', 30),
// //   ];

// //   return [
// //     new charts.Series<MyData, String>(
// //       id: 'Values',
// //       domainFn: (MyData data, _) => data.label,
// //       measureFn: (MyData data, _) => data.value,
// //       data: data,
// //       labelAccessorFn: (MyData data, _) => '${data.label}: ${data.value}%',
// //     )
// //   ];
// // }

// // class MyData {
// //   final String label;
// //   final int value;

// //   MyData(this.label, this.value);
// // }


// import 'package:flutter/material.dart';
// import 'package:charts_flutter/flutter.dart' as charts;

// class PieChartScreen extends StatefulWidget {
//   const PieChartScreen({Key? key}) : super(key: key);

//   @override
//   _PieChartScreenState createState() => _PieChartScreenState();
// }

// class _PieChartScreenState extends State<PieChartScreen> {
//   final List<charts.Series> seriesList = _createSampleData();
//   bool animate = true;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Pie Chart Example'),
//       ),
//       body: SizedBox(
//         height: 700,
//         width: 700,
//         child: Center(
//           child: MyPieChart(
//             seriesList: seriesList,
//             animate: animate,
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           setState(() {
//             animate = !animate;
//           });
//         },
//         tooltip: 'Animate',
//         child: Icon(Icons.play_arrow),
//       ),
//     );
//   }

//   static List<charts.Series<MyData, String>> _createSampleData() {
//     final data = [
//       MyData('Value 1', 30),
//       MyData('Value 2', 40),
//       MyData('Value 3', 30),
//     ];

//     return [
//       charts.Series<MyData, String>(
//         id: 'Values',
//         domainFn: (MyData data, _) => data.label,
//         measureFn: (MyData data, _) => data.value,
//         data: data,
//         labelAccessorFn: (MyData data, _) => '${data.label}: ${data.value}%',
//       )
//     ];
//   }
// }

// class MyData {
//   final String label;
//   final int value;

//   MyData(this.label, this.value);
// }

// class MyPieChart extends StatelessWidget {
//   final List<charts.Series> seriesList;
//   final bool animate;

//   MyPieChart({required this.seriesList, required this.animate});

//   @override
//   Widget build(BuildContext context) {
//     return charts.PieChart(
//       seriesList,
//       animate: animate,
//       defaultRenderer: charts.ArcRendererConfig(
//         arcRendererDecorators: [
//           charts.ArcLabelDecorator(
//             labelPosition: charts.ArcLabelPosition.auto,
//           ),
//         ],
//       ),
//     );
//   }
// }
