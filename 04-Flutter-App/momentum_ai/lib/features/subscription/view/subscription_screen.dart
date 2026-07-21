import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../view_model/subscription_view_model.dart';

class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(subscriptionViewModelProvider);
    final notifier = ref.read(subscriptionViewModelProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            Brightness.light, // Orange header ke liye hamesha white icons
        statusBarBrightness: Brightness.dark,
        // 👇 FIX: Dark mode mein bottom navigation bar ko dark set kar diya
        systemNavigationBarColor: isDark
            ? const Color(0xFF121212)
            : const Color(0xFFF3F4F6),
        systemNavigationBarIconBrightness: isDark
            ? Brightness.light
            : Brightness.dark,
      ),
      child: Scaffold(
        extendBody: true,
        // 👇 FIX: Hardcoded white hata kar Theme ka scaffold color use kiya
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // 👇 FIX: Key add kiya taake IndexedStack force rebuild kare
        key: const ValueKey('subscription_screen'),
        body: Stack(
          children: [
            // 1. BACKGROUND LAYER (Status bar ke peeche phailne ke liye)
            Positioned.fill(
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFF8C00), Color(0xFFFF2D55)],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
              ),
            ),

            // 2. CONTENT LAYER
            SafeArea(
              bottom: false,
              child: ListView(
                padding: const EdgeInsets.only(bottom: 120),
                children: [
                  // --- Header Content ---
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const FaIcon(
                              FontAwesomeIcons.arrowLeft,
                              color: Colors.white,
                              size: 22,
                            ),
                            onPressed: () => context.pop(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(12),
                          // 👇 FIX: Dark mode mein star ka background dark orange ho jayega
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFFFF8C00).withValues(alpha: 0.2)
                                : Colors.orange.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.4),
                              width: 2,
                            ),
                          ),
                          child: const FaIcon(
                            FontAwesomeIcons.star,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Go Pro',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Unlock unlimited AI power for your productivity',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // --- 2. Pricing Card ---
                  Transform.translate(
                    offset: const Offset(0, -30),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        // 👇 FIX: Hardcoded white hata kar Theme.cardColor laga diya
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Toggle Buttons
                            Container(
                              padding: const EdgeInsets.all(4),
                              // 👇 FIX: Toggle background dark mode mein soft ho jayega
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).dividerColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () =>
                                          notifier.toggleBillingCycle(false),
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: !state.isYearly
                                              ? Theme.of(context).cardColor
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            100,
                                          ),
                                          boxShadow: !state.isYearly
                                              ? [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withValues(
                                                          alpha: 0.04,
                                                        ),
                                                    blurRadius: 10,
                                                  ),
                                                ]
                                              : [],
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Monthly',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              color: !state.isYearly
                                                  ? (isDark
                                                        ? Colors.white
                                                        : const Color(
                                                            0xFF111827,
                                                          ))
                                                  : (isDark
                                                        ? Colors.white
                                                              .withValues(
                                                                alpha: 0.4,
                                                              )
                                                        : const Color(
                                                            0xFF9CA3AF,
                                                          )),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () =>
                                          notifier.toggleBillingCycle(true),
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: state.isYearly
                                              ? Theme.of(context).cardColor
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            100,
                                          ),
                                          boxShadow: state.isYearly
                                              ? [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withValues(
                                                          alpha: 0.04,
                                                        ),
                                                    blurRadius: 10,
                                                  ),
                                                ]
                                              : [],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Yearly',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                color: state.isYearly
                                                    ? (isDark
                                                          ? Colors.white
                                                          : const Color(
                                                              0xFF111827,
                                                            ))
                                                    : (isDark
                                                          ? Colors.white
                                                                .withValues(
                                                                  alpha: 0.4,
                                                                )
                                                          : const Color(
                                                              0xFF9CA3AF,
                                                            )),
                                              ),
                                            ),
                                            if (!state.isYearly) ...[
                                              const SizedBox(width: 6),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFF10B981,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        100,
                                                      ),
                                                ),
                                                child: Text(
                                                  'Save 40%',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w900,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Pricing Display
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        '\$${state.displayedPrice.toStringAsFixed(2)}',
                                    // 👇 FIX: Dynamic price text color
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.w900,
                                      color: isDark
                                          ? Colors.white
                                          : const Color(0xFF111827),
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' per month',
                                    // 👇 FIX: Dynamic muted text color
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? Colors.white.withValues(alpha: 0.6)
                                          : const Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (state.isYearly) ...[
                              const SizedBox(height: 4),
                              Text(
                                'billed \$${state.totalPrice.toStringAsFixed(2)}/year',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.6)
                                      : const Color(0xFF9CA3AF),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.sackDollar,
                                    size: 14,
                                    color: Color(0xFFF59E0B),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Save \$47.88 per year',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF10B981),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            const SizedBox(height: 20),

                            // Primary Button (Gradient fixed, no changes needed)
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFFF8C00),
                                        Color(0xFFFF2D55),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(100),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFFFF8C00,
                                        ).withValues(alpha: 0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Start 7-Day Free Trial',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Cancel anytime · No credit card for trial',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.5)
                                    : const Color(0xFF9CA3AF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // --- 3. Features List ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      // 👇 FIX: Card color theme ke hisaab se
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Everything in Pro',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ..._proFeaturesList.map(
                            (feature) => Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.circleCheck,
                                    color: Color(0xFF10B981),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      feature,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: isDark
                                            ? Colors.white
                                            : const Color(0xFF111827),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --- 4. Comparison Table ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      // 👇 FIX: Card color theme ke hisaab se
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Table(
                        columnWidths: const {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(1),
                          2: FlexColumnWidth(1),
                        },
                        children: [
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Text(
                                  'FEATURE',
                                  // 👇 FIX: Dynamic header color
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.6),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Center(
                                  child: Text(
                                    'FREE',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.6),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Center(
                                  child: Text(
                                    'PRO',
                                    style: const TextStyle(
                                      color: Color(0xFF6366F1),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ..._comparisonData.map((item) {
                            return TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  child: Text(
                                    item['feature'] as String,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: isDark
                                          ? Colors.white
                                          : const Color(0xFF111827),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  child: Center(
                                    child: Text(
                                      item['free'] as String,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? Colors.white.withValues(
                                                alpha: 0.6,
                                              )
                                            : const Color(0xFF9CA3AF),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  child: Center(
                                    child: Text(
                                      item['pro'] as String,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF4F46E5),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --- 5. Teams Plan Banner ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF7C3AED,
                            ).withValues(alpha: 0.25),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.users,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Teams Plan',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Shared workspace · Task assignment · Team analytics',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 46,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withValues(
                                  alpha: 0.15,
                                ),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Contact Sales',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const FaIcon(
                                    FontAwesomeIcons.arrowRight,
                                    size: 14,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Data Constants ---
const List<String> _proFeaturesList = [
  'Unlimited AI requests',
  'Unlimited tasks & projects',
  'AI Daily Planner',
  'AI Meeting Summarizer',
  'AI Productivity Coaching',
  'Advanced Analytics',
  'Unlimited habits & goals',
  'Priority support',
  'Custom themes',
  'Export reports (PDF, CSV)',
  'Cloud backup',
  'Early access to new AI models',
];

const List<Map<String, String>> _comparisonData = [
  {'feature': 'AI Requests', 'free': '50/mo', 'pro': 'Unlimited'},
  {'feature': 'Tasks', 'free': '50', 'pro': 'Unlimited'},
  {'feature': 'Projects', 'free': '3', 'pro': 'Unlimited'},
  {'feature': 'Analytics', 'free': 'Basic', 'pro': 'Advanced'},
  {'feature': 'AI Planner', 'free': '—', 'pro': '✓'},
  {'feature': 'Meeting AI', 'free': '—', 'pro': '✓'},
  {'feature': 'Coaching', 'free': '—', 'pro': '✓'},
];
