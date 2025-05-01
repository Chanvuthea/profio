import 'package:flutter/material.dart';
import 'package:professional_profiles/data/services/api_service.dart';
import 'package:professional_profiles/data/repositories/profile_repository.dart';
import 'package:professional_profiles/presentation/screens/profile_list_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Professional Profiles',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: Provider(
        create: (_) => ProfileRepository(apiService: ApiService()),
        child: ProfileListScreen(),
      ),
    );
  }
}
