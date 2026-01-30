import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AwsConsoleApp());
}

class AwsConsoleApp extends StatelessWidget {
  const AwsConsoleApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryPurple = Color(0xFF6A1B9A);
    return MaterialApp(
      title: 'Aws console',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF6F0FB),
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryPurple,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryPurple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        listTileTheme: const ListTileThemeData(
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6A1B9A),
              Color(0xFF8E24AA),
              Color(0xFFF6F0FB),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6A1B9A).withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.cloud,
                          size: 42,
                          color: Color(0xFF6A1B9A),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Aws console',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A148C),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Bienvenue',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF6A1B9A),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const ServicesPage()),
                          );
                        },
                        child: const Text('Entrer dans l\'app'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Services AWS')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: const Text('EC2'),
            subtitle: const Text('Compute'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const Ec2Page()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class Ec2Page extends StatefulWidget {
  const Ec2Page({super.key});

  @override
  State<Ec2Page> createState() => _Ec2PageState();
}

class _Ec2PageState extends State<Ec2Page> {
  bool _isLoading = false;
  String? _lastResult;

  Future<void> _launchEc2() async {
    setState(() {
      _isLoading = true;
      _lastResult = null;
    });

    const url = 'http://44.214.90.127:8000';
    try {
      final response = await Dio().post(
        url,
        data: {'action': 'launch_ec2'},
      );
      setState(() {
        _lastResult = 'Succes: ${response.statusCode}';
      });
    } catch (error) {
      setState(() {
        _lastResult = 'Echec: $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EC2')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _isLoading ? null : _launchEc2,
              child: _isLoading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Lancer une EC2'),
            ),
            const SizedBox(height: 16),
            if (_lastResult != null)
              Text(
                _lastResult!,
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
