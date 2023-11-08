import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:responsive_grid/responsive_grid.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/moduls_background.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: const Color.fromARGB(183, 198, 199, 157).withOpacity(0.9),
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: StaggeredGrid.count(
                crossAxisCount: 4,
                mainAxisSpacing: 60,
                crossAxisSpacing: 60,
                children: [
                  StaggeredGridTile.extent(
                    crossAxisCellCount:
                        responsiveValue(context, xs: 4, sm: 4, md: 1, lg: 1),
                    mainAxisExtent: 200.0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/logo_pdfFruty.jpeg'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  StaggeredGridTile.extent(
                    crossAxisCellCount:
                        responsiveValue(context, xs: 1, sm: 1, md: 3, lg: 3),
                    mainAxisExtent: 200,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue, // Borde azul
                          width: 2.0,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'FRUTYBOX S.A',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 34.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Times New Roman',
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: RichText(
                                maxLines: null,
                                textAlign: TextAlign.center,
                                text: const TextSpan(
                                  text:
                                      'Somos una compañía conformada por un equipo de profesionales\n'
                                      'especializados en producción, comercialización y exportación de frutas.\n'
                                      'Nacido en 2018 para ser una nueva alternativa en el sector bananero.\n'
                                      'Nuestro producto se comercializa en destinos como Grecia, Rusia, Turquía,\n'
                                      'Irak, Albania, Irlanda y otros.',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
