// lib/features/tasks/view/tasks_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_model/tasks_view_model.dart';
import '../model/task_model.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

// 👇 FIX: SingleTickerProviderStateMixin ko TickerProviderStateMixin mein change kiya
class _TasksScreenState extends ConsumerState<TasksScreen>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Today', 'High', 'Work', 'Done'];
  late final List<AnimationController> _itemControllers;
  late final List<Animation<double>> _itemAnimations;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _itemControllers = List.generate(5, (index) {
      return AnimationController(
        vsync: this, // Ab error nahi aayega
        duration: Duration(milliseconds: 600 + (index * 100)),
      );
    });
    _itemAnimations = _itemControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutQuart),
      );
    }).toList();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        for (var controller in _itemControllers) {
          controller.forward();
        }
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _itemControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final tasks = ref.watch(tasksViewModelProvider);
    final filteredTasks = tasks.where((task) {
      if (_selectedFilter == 'All') return true;
      if (_selectedFilter == 'Today') return task.time.contains('Today');
      if (_selectedFilter == 'High') return task.priority == 'High';
      if (_selectedFilter == 'Work') return task.tags.contains('Work');
      if (_selectedFilter == 'Done') return task.isCompleted == true;
      return true;
    }).toList();

    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '2 of 8 completed',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF9CA3AF),
                            ),
                          ),
                          Text(
                            'My Tasks',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF111827),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFF6366F1),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF6366F1,
                              ).withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            // Add Task button logic
                          },
                          child: const Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F3FF),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFFEDE9FE),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color(0xFF7C3AED),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.auto_awesome_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AI Task Creator',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF111827),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '*Finish report before Thursday 3pm*',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _AIActionButton(icon: Icons.mic_rounded),
                        const SizedBox(width: 8),
                        _AIActionButton(icon: Icons.edit_rounded),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        icon: const Icon(
                          Icons.search_rounded,
                          color: Color(0xFF9CA3AF),
                          size: 22,
                        ),
                        hintText: 'Search tasks...',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF9CA3AF),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 👇 FIXED FILTER CHIPS (GestureDetector ki jagah InkWell use kiya)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _filters.map((filter) {
                        final isSelected = _selectedFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(100),
                            onTap: () =>
                                setState(() => _selectedFilter = filter),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOutCubic,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF6366F1)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: const Color(
                                            0xFF6366F1,
                                          ).withValues(alpha: 0.25),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.04,
                                          ),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                              ),
                              child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 250),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF6B7280),
                                ),
                                child: Text(filter),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  if (filteredTasks.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Center(
                        child: Text(
                          'No tasks found',
                          style: TextStyle(
                            color: const Color(0xFF9CA3AF),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    )
                  else
                    Column(
                      children: filteredTasks.asMap().entries.map((entry) {
                        int index = entry.key;
                        TaskModel task = entry.value;
                        int originalIndex = tasks.indexWhere(
                          (t) => t.id == task.id,
                        );
                        if (originalIndex == -1) originalIndex = index;
                        final animation =
                            _itemAnimations[originalIndex %
                                _itemAnimations.length];

                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.4),
                              end: Offset.zero,
                            ).animate(animation),
                            child: _TaskCard(
                              task: task,
                              onToggle: () => ref
                                  .read(tasksViewModelProvider.notifier)
                                  .toggleTaskCompletion(task.id),
                            ),
                          ),
                        );
                      }).toList(),
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

// --- Sub-Widgets ---

class _AIActionButton extends StatelessWidget {
  final IconData icon;
  const _AIActionButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Icon(icon, color: const Color(0xFF6D28D9), size: 18),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onToggle;

  const _TaskCard({required this.task, required this.onToggle});

  Color _getTagTextColor(String tag) {
    if (tag == 'High') return const Color(0xFFDC2626);
    if (tag == 'Medium') return const Color(0xFFD97706);
    if (tag == 'Low') return const Color(0xFF059669);
    if (tag == 'Work') return const Color(0xFF6D28D9);
    if (tag == 'Finance') return const Color(0xFF2563EB);
    if (tag == 'Meeting') return const Color(0xFF0284C7);
    if (tag == 'Email') return const Color(0xFF9333EA);
    return const Color(0xFF4B5563);
  }

  Color _getTagBgColor(String tag) {
    if (tag == 'High') return const Color(0xFFFEE2E2);
    if (tag == 'Medium') return const Color(0xFFFEF3C7);
    if (tag == 'Low') return const Color(0xFFD1FAE5);
    if (tag == 'Work') return const Color(0xFFEDE9FE);
    if (tag == 'Finance') return const Color(0xFFDBEAFE);
    if (tag == 'Meeting') return const Color(0xFFE0F2FE);
    if (tag == 'Email') return const Color(0xFFF3E8FF);
    return const Color(0xFFF3F4F6);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 50,
            decoration: BoxDecoration(
              color: task.accentColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 14),

          // Checkbox toggle
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: task.isCompleted ? task.accentColor : Colors.transparent,
                border: Border.all(
                  color: task.isCompleted
                      ? task.accentColor
                      : const Color(0xFFD1D5DB),
                  width: 2,
                ),
              ),
              child: AnimatedScale(
                scale: task.isCompleted ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  children: task.tags
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getTagBgColor(tag),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: _getTagTextColor(tag),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 6),
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: task.isCompleted
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF111827),
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: Color(0xFF9CA3AF),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      task.time,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (task.isAIGenerated)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3E8FF),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.auto_awesome_rounded,
                              color: Color(0xFF9333EA),
                              size: 10,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'AI',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF9333EA),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
