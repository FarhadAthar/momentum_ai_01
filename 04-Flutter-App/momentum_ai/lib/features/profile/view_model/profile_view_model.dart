import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/profile_state.dart';
import '../../../core/services/api_service.dart';

final profileViewModelProvider =
    NotifierProvider<ProfileViewModel, AsyncValue<ProfileState>>(() {
      return ProfileViewModel();
    });

class ProfileViewModel extends Notifier<AsyncValue<ProfileState>> {
  @override
  AsyncValue<ProfileState> build() {
    fetchProfile();
    return const AsyncValue.loading();
  }

  Future<void> fetchProfile() async {
    state = const AsyncValue.loading();
    try {
      final data = await ApiService.getProfile();
      final profile = ProfileState.fromJson(data);
      state = AsyncValue.data(profile);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
