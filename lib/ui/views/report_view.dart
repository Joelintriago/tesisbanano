import 'package:flutter/material.dart';

class ReportesView extends StatefulWidget {

  @override
  State<ReportesView> createState() => _ReportesViewState();
}

class _ReportesViewState extends State<ReportesView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
         height: MediaQuery.of(context).size.height,
                    color: const Color.fromARGB(183, 198, 199, 157)
                        .withOpacity(0.9),
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    child: const Center(
                      child: Text('Reportes'),
                    ),
      ),
    );
  }
}