import 'package:flutter/material.dart';

class OperativoView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Número de pestañas (Usuarios y Permisos)
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white, // Fondo blanco
                  child: const Center(
                    child: Text('Inventario', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  color: Colors.white, // Fondo blanco
                  child: const Center(
                    child: Text('Costo', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  color: Colors.white, // Fondo blanco
                  child: const Center(
                    child: Text('Rentabilidad', style: TextStyle(fontSize: 16)),
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    color: const Color.fromARGB(183, 198, 199, 157)
                        .withOpacity(0.9),
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    child: const Center(
                      child: Text('Inventario'),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    color: const Color.fromARGB(183, 198, 199, 157)
                        .withOpacity(0.9),
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    child: const Center(
                      child: Text('Costos'),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    color: const Color.fromARGB(183, 198, 199, 157)
                        .withOpacity(0.9),
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    child: const Center(
                      child: Text('Rentabilidad'),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
