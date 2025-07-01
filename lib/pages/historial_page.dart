import 'package:flutter/material.dart';

class HistorialPage extends StatelessWidget {
  const HistorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Historial'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.home),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Table(
                border: TableBorder.all(color: Colors.grey),
                defaultColumnWidth: const FixedColumnWidth(140.0),
                children: [
                  _buildTableRow(
                    ['Fecha', 'Hora', 'Código', 'Usos iniciales', 'Usos restantes', 'Descripción'],
                    isHeader: true,
                  ),
                  _buildTableRow(['01/07/2025', '08:30', '1234', '5', '3', 'Visita de Juan']),
                  _buildTableRow(['30/06/2025', '14:10', '5678', '3', '0', 'Repartidor Amazon']),
                  _buildTableRow(['29/06/2025', '11:45', '9876', '2', '1', 'Servicio técnico']),
                  _buildTableRow(['28/06/2025', '17:20', '1111', '1', '0', 'Electricista']),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(List<String> cells, {bool isHeader = false}) {
    return TableRow(
      decoration: isHeader
          ? const BoxDecoration(color: Colors.blueAccent)
          : const BoxDecoration(color: Colors.white),
      children: cells.map((cell) {
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            cell,
            style: TextStyle(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              color: isHeader ? Colors.white : Colors.black,
              fontSize: 14,
            ),
          ),
        );
      }).toList(),
    );
  }
}
