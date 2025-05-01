import 'package:professional_profiles/data/services/api_service.dart';
import 'package:professional_profiles/domain/entities/profile.dart';

class ProfileRepository {
  final ApiService apiService;

  ProfileRepository({required this.apiService});

  Future<List<Profile>> getProfiles() async {
    final profilesData = await apiService.fetchProfiles();
    return profilesData
        .map((profileData) => Profile.fromJson(profileData))
        .toList();
  }
}
