import 'package:flutter/material.dart';
import 'package:pluto_layout/pluto_layout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlutoLayoutTabsOrChild(
      child: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(
              minWidth: 300,
              maxWidth: 800,
            ),
            alignment: Alignment.center,
            child: const Padding(
              padding: EdgeInsets.all(50),
              child: Center(
                child: _FeatureContainer(
                  title: "Usage",
                  features: [
                    _Feature(
                      description:
                          "A small overview of all the options you have:",
                    ),
                    _Feature(
                      title: "Code Files",
                      description:
                          "Lets you open all the code files of your program.",
                    ),
                    _Feature(
                      title: "Settings",
                      description:
                          "Lets you go back to the startpage to load a different trace.",
                    ),
                    _Feature(
                      title: "Symbolic Tree",
                      description:
                          "Shows the execution tree to visualize the different traces of the symbolic execution.",
                    ),
                    _Feature(
                      title: "Stats",
                      description:
                          "Shows the stats of the whole program.",
                    ),
                    _Feature(
                      title: "File Stats",
                      description:
                          "Shows the stats of the different code files.",
                    ),
                    _Feature(
                      title: "Symbolic/Concrete Values",
                      description:
                          "Shows the symbolic and concrete values of the variables in your program.",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureContainer extends StatelessWidget {
  const _FeatureContainer({
    required this.title,
    required this.features,
  });

  final String title;

  final List<_Feature> features;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final lastItem = features.last;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.dialogBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final feature in features)
                    if (lastItem != feature) ...[
                      feature,
                      const SizedBox(height: 15),
                    ] else
                      feature,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Feature extends StatelessWidget {
  const _Feature({
    this.title,
    required this.description,
  });

  final String? title;

  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      direction: Axis.horizontal,
      children: [
        if (title != null) ...[
          DecoratedBox(
            decoration: BoxDecoration(
              color: theme.secondaryHeaderColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Text(title!),
            ),
          ),
          const SizedBox(width: 10),
        ],
        Text(description),
      ],
    );
  }
}
