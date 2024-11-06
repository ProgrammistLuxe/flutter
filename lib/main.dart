import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_modular/flutter_modular.dart';
import './favorites-list.dart';
import './request-form.dart';

void main() {
  Modular.setInitialRoute('/generator');
  runApp(
    ModularApp(
      module: AppModule(),
      child: ChangeNotifierProvider(
        create: (context) => MyAppState(),
        child: MyApp(),
      ),
    ),
  );
}

// class AppWidget extends StatelessWidget {
//   Widget build(BuildContext context) {
//     Modular.setInitialRoute('/');
//     return ChangeNotifierProvider(
//       create: (context) => MyAppState(),
//     return MaterialApp.router(
//       title: 'Start app',
//       theme: ThemeData(
//         useMaterial3: true,
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
//       ),
//       routerConfig: Modular.routerConfig,
//     );
//     )
//   }
// }

class AppModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child('/', child: (context) => MyHomePage(), children: [
      ChildRoute('/generator', child: (context) => GeneratorPage()),
      ChildRoute('/favorites', child: (context) => FavoritesPage()),
      ChildRoute('/my-page', child: (context) => JohnPage()),
      ChildRoute('/form', child: (context) => MyFormPage()),
    ]);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Namer App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
    );
  }
}

class MyAppState with ChangeNotifier {
  var current = WordPair.random();
  var tag = 'john';
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }

  void deleteFavorite(WordPair pair) {
    favorites.remove(pair);
    notifyListeners();
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
    required this.tag,
  });

  final WordPair pair;
  final String tag;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayLarge!.copyWith(
      color: theme.primaryColorDark,
    );
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Text(pair.asUpperCase,
              style: style, semanticsLabel: "${pair.first} ${pair.second}"),
          SizedBox(width: 15),
          Text(tag, style: style)
        ],
      ),
    ));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    // Widget page;

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 500,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Favorites'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.developer_board),
                    label: Text('Jonn page'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.input),
                    label: Text('Form page'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                    switch (selectedIndex) {
                      case 0:
                        Modular.to.navigate('/generator');
                        break;
                      case 1:
                        Modular.to.navigate('/favorites');
                        break;
                      case 2:
                        Modular.to.navigate('/my-page');
                        break;
                      case 3:
                        Modular.to.navigate('/form');
                        break;
                      default:
                        throw UnimplementedError(
                            'no widget for $selectedIndex');
                    }
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: const RouterOutlet(),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<MyAppState>(context);

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }
}

class JohnPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<MyAppState>(context);
    // var pair = appState.current;
    var favorites = appState.favorites;

    IconData icon = Icons.delete_forever;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FavoritesList(
              favorites: favorites, deleteFavorite: appState.deleteFavorite)
        ],
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<MyAppState>(context);
    var pair = appState.current;
    var favorites = appState.favorites;
    var tag = appState.tag;
    IconData icon;
    if (favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair, tag: tag),
          SizedBox(height: 15),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Click me!!!'),
              ),
              SizedBox(width: 15),
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
            ],
          )
        ],
      ),
    ));
  }
}
