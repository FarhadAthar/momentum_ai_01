import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AddTaskBottomSheet extends StatefulWidget {
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
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final TextEditingController _aiInputController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  // State variables for premium pickers
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedPriority;
  String? _selectedCategory;

  bool _isAIAutoExtracted = false;

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

      // Future Backend Mock
      if (text.toLowerCase().contains('prepare proposal')) {
        _titleController.text = 'Prepare proposal for John';
        _selectedCategory = 'Work';
        _selectedPriority = 'High';

        // Auto set date to Friday (Mock logic)
        final now = DateTime.now();
        final daysUntilFriday = DateTime.friday - now.weekday;
        final nextFriday = now.add(
          Duration(
            days: daysUntilFriday < 0 ? daysUntilFriday + 7 : daysUntilFriday,
          ),
        );
        _selectedDate = nextFriday;
        _selectedTime = const TimeOfDay(hour: 17, minute: 0); // 5 PM
      }
    });
  }

  // Premium Date & Time Picker
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

    // Premium dynamic formatting
    if (DateUtils.isSameDay(date, now)) return 'Today, $timeString';
    if (DateUtils.isSameDay(date, now.add(const Duration(days: 1)))) {
      return 'Tomorrow, $timeString';
    }

    return DateFormat(
      'EEEE, h:mm a',
    ).format(DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
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
                      color: const Color(0xFF111827),
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
                  color: const Color(0xFFF5F3FF),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFEDE9FE), width: 1),
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
                        color: const Color(0xFF111827),
                      ),
                      decoration: InputDecoration(
                        hintText: '"Prepare proposal for John by Friday 5pm"',
                        hintStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF9CA3AF),
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
              ),

              const SizedBox(height: 12),

              // --- PREMIUM: Deadline Picker Row ---
              GestureDetector(
                onTap: _pickDateTime,
                child: _buildPickerRow(
                  label: 'Deadline',
                  value: _formatDateTime(),
                  icon: Icons.calendar_today_rounded,
                  isAutoFilled: _selectedDate != null,
                ),
              ),

              const SizedBox(height: 12),

              // --- PREMIUM: Priority Selector ---
              _buildPrioritySelector(),

              const SizedBox(height: 12),

              // --- PREMIUM: Category Selector ---
              _buildCategorySelector(),

              const SizedBox(height: 24),

              // --- Add Task Button ---
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    // Extract values
                    final title = _titleController.text.trim();
                    final deadline =
                        _formatDateTime(); // You can also store raw date
                    final priority = _selectedPriority ?? 'Medium';
                    final category = _selectedCategory ?? 'Work';
                    final estimate =
                        '2 hours'; // Could add a controller for this

                    // Call the callback
                    widget.onTaskAdded(
                      title,
                      deadline,
                      priority,
                      category,
                      estimate,
                    );
                    Navigator.pop(context);
                  },
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Add Task',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
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
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        controller: controller,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF111827),
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF9CA3AF),
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
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF9CA3AF), size: 18),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF9CA3AF),
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
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF111827),
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

  Widget _buildPrioritySelector() {
    final priorities = ['High', 'Medium', 'Low'];
    final colors = [
      const Color(0xFFEF4444),
      const Color(0xFFF59E0B),
      const Color(0xFF10B981),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
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
                color: const Color(0xFF9CA3AF),
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
                          : const Color(0xFF6B7280),
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

  Widget _buildCategorySelector() {
    final categories = ['Work', 'Personal', 'Meeting', 'Finance'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
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
                color: const Color(0xFF9CA3AF),
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
                          : const Color(0xFFE5E7EB),
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
                          : const Color(0xFF6B7280),
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
