// lib/features/subscription/view_model/subscription_view_model.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/subscription_state.dart';

final subscriptionViewModelProvider =
    NotifierProvider<SubscriptionViewModel, SubscriptionState>(() {
      return SubscriptionViewModel();
    });

class SubscriptionViewModel extends Notifier<SubscriptionState> {
  @override
  SubscriptionState build() {
    return SubscriptionState();
  }

  void toggleBillingCycle(bool isYearly) {
    if (state.isYearly != isYearly) {
      state = state.copyWith(isYearly: isYearly);
    }
  }
}
