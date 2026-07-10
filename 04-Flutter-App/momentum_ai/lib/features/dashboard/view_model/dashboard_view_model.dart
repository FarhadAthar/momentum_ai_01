import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/dashboard_state.dart';

final dashboardViewModelProvider =
    NotifierProvider<DashboardViewModel, DashboardState>(() {
      return DashboardViewModel();
    });

class DashboardViewModel extends Notifier<DashboardState> {
  @override
  DashboardState build() {
    return const DashboardState().copyWith(
      meetings: const [
        MeetingModel(title: 'Design Review', time: '10:00 AM', peopleCount: 4),
        MeetingModel(
          title: 'Client Call - Acme',
          time: '2:00 PM',
          peopleCount: 2,
        ),
      ],
      priorities: const [
        TaskPriorityModel(
          title: 'Prepare client proposal',
          timeEstimate: '2h',
          type: 'urgent',
          tags: ['URGENT', 'Work'],
        ),
        TaskPriorityModel(
          title: 'Review Q3 financial report',
          timeEstimate: '45m',
          type: 'finance',
          tags: ['Finance'],
        ),
        TaskPriorityModel(
          title: 'Team standup call',
          timeEstimate: '30m',
          type: 'meeting',
          tags: ['URGENT', 'Meeting'],
        ),
      ],
    );
  }
}
