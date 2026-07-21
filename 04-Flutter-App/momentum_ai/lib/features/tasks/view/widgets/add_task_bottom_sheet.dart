import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/services/api_service.dart';
import '../../view_model/tasks_view_model.dart';

class AddTaskBottomSheet extends ConsumerStatefulWidget {
  final Function(
    String title,
    String deadline,
    String priority,
    String category,
    String estimate,
  )
  onTaskAdded;

  const AddTaskBottomSheet({super.key, required this.onTaskAdded});

  @override
  ConsumerState<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends ConsumerState<AddTaskBottomSheet> {
  final TextEditingController _aiInputController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedPriority;
  String? _selectedCategory;

  bool _isAIAutoExtracted = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _aiInputController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _triggerAIAutoExtract() {
    final text = _aiInputController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _isAIAutoExtracted = true;

      if (text.toLowerCase().contains('prepare proposal')) {
        _titleController.text = 'Prepare proposal for John';
        _selectedCategory = 'Work';
        _selectedPriority = 'High';

        final now = DateTime.now();
        final daysUntilFriday = DateTime.friday - now.weekday;
        final nextFriday = now.add(
          Duration(
            days: daysUntilFriday < 0 ? daysUntilFriday + 7 : daysUntilFriday,
          ),
        );
        _selectedDate = nextFriday;
        _selectedTime = const TimeOfDay(hour: 17, minute: 0);
      }
    });
  }

  Future<void> _pickDateTime() async {
    HapticFeedback.lightImpact();

    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF6366F1)),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: _selectedTime ?? TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(primary: Color(0xFF6366F1)),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDate = pickedDate;
          _selectedTime = pickedTime;
        });
      }
    }
  }

  String _formatDateTime() {
    if (_selectedDate == null || _selectedTime == null) return 'Tap to pick';

    final now = DateTime.now();
    final date = _selectedDate!;
    final time = _selectedTime!;
    final timeString = time.format(context);

    if (DateUtils.isSameDay(date, now)) return 'Today, $timeString';
    if (DateUtils.isSameDay(date, now.add(const Duration(days: 1)))) {
      return 'Tomorrow, $timeString';
    }

    return DateFormat(
      'EEEE, h:mm a',
    ).format(DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }

  Future<void> _submitTask() async {
    if (_isSubmitting) return;

    HapticFeedback.lightImpact();

    final title = _titleController.text.trim();
    final deadline = _formatDateTime();
    final priority = _selectedPriority ?? 'Medium';
    final category = _selectedCategory ?? 'Work';
    const estimate = '2 hours';

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a task title.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final newTaskData = <String, dynamic>{
        'title': title,
        'priority': priority,
        'tags': [category],
        'time': deadline,
      };

      await ApiService.createTask(newTaskData);

      // Rebuild the async tasks provider so the newly created API task appears.
      ref.invalidate(tasksViewModelProvider);

      if (!mounted) return;

      widget.onTaskAdded(title, deadline, priority, category, estimate);

      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to add task: $error')));
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.only(top: 20),
      // 👇 FIX: Bottom sheet background color theme aware
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --- Header ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'New Task',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                      fontFamily: 'SpaceGrotesk',
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Color(0xFF9CA3AF),
                    ),
                    splashRadius: 20,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- AI Auto-Extract Card ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF2D1B4E)
                      : const Color(0xFFF5F3FF),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF3E2A5E)
                        : const Color(0xFFEDE9FE),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.auto_awesome_rounded,
                          color: Color(0xFF7C3AED),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'AI Auto-Extract',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF7C3AED),
                            fontFamily: 'Manrope',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _aiInputController,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF111827),
                        fontFamily: 'Manrope',
                      ),
                      decoration: InputDecoration(
                        hintText: '"Prepare proposal for John by Friday 5pm"',
                        hintStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.6),
                          fontFamily: 'Manrope',
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onSubmitted: (_) => _triggerAIAutoExtract(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // --- Title Field ---
              _buildTextInputRow(
                'Title',
                _titleController,
                isAutoFilled: _isAIAutoExtracted,
                isDark: isDark,
              ),

              const SizedBox(height: 12),

              // --- Deadline Picker Row ---
              GestureDetector(
                onTap: _pickDateTime,
                child: _buildPickerRow(
                  label: 'Deadline',
                  value: _formatDateTime(),
                  icon: Icons.calendar_today_rounded,
                  isAutoFilled: _selectedDate != null,
                  isDark: isDark,
                ),
              ),

              const SizedBox(height: 12),

              // --- Priority Selector ---
              _buildPrioritySelector(isDark: isDark),

              const SizedBox(height: 12),

              // --- Category Selector ---
              _buildCategorySelector(isDark: isDark),

              const SizedBox(height: 24),

              // --- Add Task Button ---
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Add Task',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    fontFamily: 'Manrope',
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildTextInputRow(
    String label,
    TextEditingController controller, {
    bool isAutoFilled = false,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      // 👇 FIX: Input row background theme aware
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        controller: controller,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.white : const Color(0xFF111827),
          fontFamily: 'Manrope',
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
            fontFamily: 'Manrope',
          ),
          suffixIcon: isAutoFilled && controller.text.isNotEmpty
              ? const Icon(
                  Icons.check_rounded,
                  color: Color(0xFF10B981),
                  size: 18,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildPickerRow({
    required String label,
    required String value,
    required IconData icon,
    required bool isAutoFilled,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      // 👇 FIX: Picker row background theme aware
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
                size: 18,
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                  fontFamily: 'Manrope',
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: value == 'Tap to pick'
                      ? Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6)
                      : (isDark ? Colors.white : const Color(0xFF111827)),
                  fontFamily: 'Manrope',
                ),
              ),
              if (isAutoFilled && value != 'Tap to pick') ...[
                const SizedBox(width: 8),
                const Icon(
                  Icons.check_rounded,
                  color: Color(0xFF10B981),
                  size: 18,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrioritySelector({required bool isDark}) {
    final priorities = ['High', 'Medium', 'Low'];
    final colors = [
      const Color(0xFFEF4444),
      const Color(0xFFF59E0B),
      const Color(0xFF10B981),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      // 👇 FIX: Priority selector background theme aware
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
            child: Text(
              'Priority',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
                fontFamily: 'Manrope',
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(priorities.length, (index) {
              final p = priorities[index];
              final isSelected = _selectedPriority == p;
              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() => _selectedPriority = p);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colors[index].withValues(alpha: 0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? colors[index] : Colors.transparent,
                      width: 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: colors[index].withValues(alpha: 0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Text(
                    p,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: isSelected
                          ? colors[index]
                          : (isDark
                                ? Colors.white.withValues(alpha: 0.6)
                                : const Color(0xFF6B7280)),
                      fontFamily: 'Manrope',
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildCategorySelector({required bool isDark}) {
    final categories = ['Work', 'Personal', 'Meeting', 'Finance'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      // 👇 FIX: Category selector background theme aware
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
            child: Text(
              'Category',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
                fontFamily: 'Manrope',
              ),
            ),
          ),
          Wrap(
            spacing: 8,
            children: categories.map((cat) {
              final isSelected = _selectedCategory == cat;
              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() => _selectedCategory = cat);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFEDE9FE)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF7C3AED)
                          : Theme.of(
                              context,
                            ).dividerColor.withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    cat,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: isSelected
                          ? const Color(0xFF7C3AED)
                          : (isDark
                                ? Colors.white.withValues(alpha: 0.6)
                                : const Color(0xFF6B7280)),
                      fontFamily: 'Manrope',
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
