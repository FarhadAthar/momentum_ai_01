// lib/features/profile/view_model/profile_view_model.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/profile_state.dart';

final profileViewModelProvider =
    NotifierProvider<ProfileViewModel, ProfileState>(() {
      return ProfileViewModel();
    });

class ProfileViewModel extends Notifier<ProfileState> {
  @override
  ProfileState build() {
    return const ProfileState();
  }
}


