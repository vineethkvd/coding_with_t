import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

// Define App State
class AppState extends ChangeNotifier {
  String _currentPath = "/";

  String get currentPath => _currentPath;

  void updatePath(String path) {
    _currentPath = path;
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}

// Breadcrumb Widget
class Breadcrumb extends StatelessWidget {
  final List<String> paths;

  const Breadcrumb({Key? key, required this.paths}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: paths.asMap().entries.map((entry) {
        final index = entry.key;
        final path = entry.value;
        final isLast = index == paths.length - 1;

        return Row(
          children: [
            GestureDetector(
              onTap: () {
                if (!isLast) {
                  context.go(path);
                }
              },
              child: Text(
                path,
                style: TextStyle(
                  color: isLast ? Colors.black : Colors.blue,
                  fontWeight: isLast ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (!isLast)
              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
          ],
        );
      }).toList(),
    );
  }
}

// Define Routes
final GoRouter _router = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardPage(),
      routes: [
        GoRoute(
          path: 'settings',
          builder: (context, state) => const SettingsPage(),
        ),
        GoRoute(
          path: 'profile',
          builder: (context, state) => const ProfilePage(),
        ),
      ],
    ),
  ],
);

// Drawer Widget
class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.lightBlueAccent],
              ),
            ),
            child: Text(
              'Navigation',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            title: const Text('Dashboard'),
            leading: const Icon(Icons.dashboard),
            selected: appState.currentPath == '/dashboard',
            selectedTileColor: Colors.blue.withOpacity(0.2),
            onTap: () {
              context.go('/dashboard');
              appState.updatePath('/dashboard');
            },
          ),
          ListTile(
            title: const Text('Settings'),
            leading: const Icon(Icons.settings),
            selected: appState.currentPath == '/dashboard/settings',
            selectedTileColor: Colors.blue.withOpacity(0.2),
            onTap: () {
              context.go('/dashboard/settings');
              appState.updatePath('/dashboard/settings');
            },
          ),
          ListTile(
            title: const Text('Profile'),
            leading: const Icon(Icons.person),
            selected: appState.currentPath == '/dashboard/profile',
            selectedTileColor: Colors.blue.withOpacity(0.2),
            onTap: () {
              context.go('/dashboard/profile');
              appState.updatePath('/dashboard/profile');
            },
          ),
        ],
      ),
    );
  }
}

// Dashboard Page
class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Breadcrumb(paths: ["/", "Dashboard"]),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16.0),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                _buildDashboardCard(
                  context,
                  icon: Icons.settings,
                  title: "Settings",
                  onTap: () => context.go('/dashboard/settings'),
                ),
                _buildDashboardCard(
                  context,
                  icon: Icons.person,
                  title: "Profile",
                  onTap: () => context.go('/dashboard/profile'),
                ),
                _buildDashboardCard(
                  context,
                  icon: Icons.analytics,
                  title: "Analytics",
                  onTap: () {},
                ),
                _buildDashboardCard(
                  context,
                  icon: Icons.message,
                  title: "Messages",
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Settings Page
class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Breadcrumb(paths: ["/", "Dashboard", "Settings"]),
          const SizedBox(height: 20),
          ListTile(
            title: const Text("Go to Profile"),
            onTap: () => context.go('/dashboard/profile'),
          ),
        ],
      ),
    );
  }
}

// Profile Page
class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Breadcrumb(paths: ["/", "Dashboard", "Profile"]),
          const SizedBox(height: 20),
          ListTile(
            title: const Text("Go to Settings"),
            onTap: () => context.go('/dashboard/settings'),
          ),
        ],
      ),
    );
  }
}
