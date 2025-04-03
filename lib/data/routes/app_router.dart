import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/pages/screens.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: '/',
      errorBuilder: (context, state) => ErrorScreen(error: state.error),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const PokemonListScreen(),
            routes: [
              GoRoute(
                path: 'pokemon/:id',
                name: 'pokemon',
                builder: (context, state) {
                  return PokemonDetailScreen(
                    pokemonID: state.pathParameters['id'] ?? "1",
                  );
                },
              )
            ]),
      ]);
});
