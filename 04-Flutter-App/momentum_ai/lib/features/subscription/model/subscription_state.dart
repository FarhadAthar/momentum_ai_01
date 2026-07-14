// lib/features/subscription/model/subscription_state.dart
class SubscriptionState {
  final bool isYearly;
  final double monthlyPrice;
  final double yearlyPrice;

  SubscriptionState({
    this.isYearly = false,
    this.monthlyPrice = 9.99,
    this.yearlyPrice = 71.88,
  });

  double get displayedPrice => isYearly ? yearlyPrice / 12 : monthlyPrice;
  double get totalPrice => isYearly ? yearlyPrice : monthlyPrice;
  String get billingPeriod => isYearly ? '/year' : '/month';

  SubscriptionState copyWith({bool? isYearly}) {
    return SubscriptionState(
      isYearly: isYearly ?? this.isYearly,
      monthlyPrice: monthlyPrice,
      yearlyPrice: yearlyPrice,
    );
  }
}


