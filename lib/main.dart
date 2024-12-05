import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<NavItem> navItems = [
    NavItem(icon: Icons.person, label: 'Person'),
    NavItem(icon: Icons.message, label: 'Message'),
    NavItem(icon: Icons.call, label: 'Call'),
    NavItem(icon: Icons.camera, label: 'Camera'),
    NavItem(icon: Icons.photo, label: 'Gallery'),
  ];

  void onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final item = navItems.removeAt(oldIndex);
      navItems.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        bottomNavigationBar: Dock(
          items: navItems,
          onReorder: onReorder,
          builder: (NavItem item) {
            return Draggable<NavItem>(
              data: item,
              feedback: Material(
                color: Colors.transparent,
                child: Icon(
                  item.icon,
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              childWhenDragging: Container(),
              child: DragTarget<NavItem>(
                onAcceptWithDetails: (details) {
                  onReorder(navItems.indexOf(details.data), navItems.indexOf(item));
                },
                builder: (BuildContext context, List<NavItem?> candidateData, List<dynamic> rejectedData) {
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.all(8),
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.primaries[e.hashCode % Colors.primaries.length],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(item.icon, color: Colors.white),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Dock widget that handles the drag and drop of items.
class Dock extends StatefulWidget {
  const Dock({
    super.key,
    this.items = const [],
    required this.builder,
    required this.onReorder,
  });

  final List<NavItem> items;
  final Widget Function(NavItem) builder;
  final Function(int, int) onReorder;

  @override
  State<Dock> createState() => _DockState();
}

class _DockState extends State<Dock> {
  late List<NavItem> _items;

  @override
  void initState() {
    super.initState();
    _items = widget.items;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(12)
            ),
            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_items.length, (index) {
                return widget.builder(_items[index]);
              }),
            ),
          ),
        ),
      ),
    );
  }
}

/// Class to define bottom navigation items
class NavItem {
  final IconData icon;
  final String label;

  NavItem({required this.icon, required this.label});
}
