import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_management/controllers/auth_controller.dart';

Widget _buildIndexDrawer() {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: const [
        DrawerHeader(
          decoration: BoxDecoration(color: Color(0xFF1F7A8C)),
          child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
        ),
        ListTile(leading: Icon(Icons.dashboard_rounded), title: Text('Dashboard')),
        ListTile(leading: Icon(Icons.inventory_2_rounded), title: Text('Products')),
        ListTile(leading: Icon(Icons.people_rounded), title: Text('Customers')),
        ListTile(leading: Icon(Icons.bar_chart_rounded), title: Text('Reports')),
        Spacer(flex: 1), // add some space before the logout button
        Divider(), // add a divider before the logout button
        // should have a line the logout button at the bottom of the drawer
        ListTile(leading: Icon(Icons.logout_rounded), title: Text('Logout')),
      ],
    ),
  );
}

class Index extends StatelessWidget {
  const Index({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthController>().state;
    final user = authState.user;

    return Scaffold(
      drawer: _buildIndexDrawer(),
      appBar: AppBar(
        title: const Text('Store Management'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => context.read<AuthController>().add(const AuthSignedOut()),
            child: const Text('Logout'),
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: 420,
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 24,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.storefront_rounded, size: 56),
              const SizedBox(height: 16),
              const Text(
                'Welcome to Store Management!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                user?.name.isNotEmpty == true ? user!.name : (authState.userEmail ?? 'You are signed in.'),
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              if (user != null) ...[
                const SizedBox(height: 12),
                Text(user.email, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
                const SizedBox(height: 4),
                Text(
                  '@${user.username}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xFF5C6672)),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
