import 'package:flutter/material.dart';
import 'package:professional_profiles/domain/entities/profile.dart';
import 'package:professional_profiles/presentation/screens/profile_detail_screen.dart';
import 'package:professional_profiles/data/repositories/profile_repository.dart';
import 'package:professional_profiles/presentation/screens/profile_image_screen.dart';
import 'package:professional_profiles/presentation/widgets/profile_card.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProfileListScreen extends StatefulWidget {
  @override
  _ProfileListScreenState createState() => _ProfileListScreenState();
}

class _ProfileListScreenState extends State<ProfileListScreen> {
  TextEditingController _searchController = TextEditingController();
  ValueNotifier<Uint8List?> imageDataNotifier = ValueNotifier<Uint8List?>(null);
  List<Profile> _allProfiles = [];
  List<Profile> _filteredProfiles = [];

  @override
  void initState() {
    loadAsset();
    super.initState();
    _searchController.addListener(_filterProfiles);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterProfiles);
    _searchController.dispose();
    imageDataNotifier.dispose();
    super.dispose();
  }

  void loadAsset() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.reload(); // Ensure the latest value is loaded
    String? base64Image = prefs.getString('myImageKey');
    if (base64Image != null) {
      Uint8List decodedBytes = base64Decode(base64Image);
      imageDataNotifier.value = decodedBytes;
    }
  }

  void _filterProfiles() {
    setState(() {
      final query = _searchController.text.toLowerCase();

      _filteredProfiles =
          _allProfiles.where((profile) {
            return profile.name.toLowerCase().contains(query) ||
                profile.skills.any(
                  (skill) => skill.toLowerCase().contains(query),
                );
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile List'),
        actions: [
          ValueListenableBuilder<Uint8List?>(
            valueListenable: imageDataNotifier,
            builder: (context, imageData, child) {
              return IconButton(
                icon:
                    imageData != null
                        ? ClipOval(
                          child: Image.memory(
                            imageData,
                            height: 30.0,
                            width: 30.0,
                            fit: BoxFit.cover,
                          ),
                        )
                        : Icon(Icons.person),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageEditorScreen(),
                    ),
                  ).then(
                    (_) => loadAsset(),
                  ); // Reload asset after returning from ImageEditorScreen
                },
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by name or skill',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Profile>>(
        future: Provider.of<ProfileRepository>(context).getProfiles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No profiles found.'));
          } else {
            if (_allProfiles.isEmpty) {
              _allProfiles = snapshot.data!;
              _filteredProfiles = _allProfiles;
            }

            return ListView.builder(
              itemCount: _filteredProfiles.length,
              itemBuilder: (context, index) {
                final profile = _filteredProfiles[index];
                return ProfileCard(
                  name: profile.name,
                  imageUrl: profile.imageUrl,
                  skills: profile.skills,
                  roles: profile.roles,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ProfileDetailScreen(profile: profile),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
