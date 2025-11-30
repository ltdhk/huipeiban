import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/theme.dart';

/// 陪诊时间管理页面
class ScheduleManagementPage extends ConsumerStatefulWidget {
  const ScheduleManagementPage({super.key});

  @override
  ConsumerState<ScheduleManagementPage> createState() =>
      _ScheduleManagementPageState();
}

class _ScheduleManagementPageState
    extends ConsumerState<ScheduleManagementPage> {
  DateTime _selectedDate = DateTime.now();

  // TODO: 从 API 获取可接单时间段
  final Map<String, List<TimeSlot>> _timeSlots = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSchedule();
  }

  /// 加载排班数据
  Future<void> _loadSchedule() async {
    setState(() => _isLoading = true);
    // TODO: 调用 API 获取排班数据
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('时间管理'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_alarm),
            onPressed: _handleBatchSet,
            tooltip: '批量设置',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // 日期选择器
                _buildDateSelector(),
                SizedBox(height: 16.h),

                // 选中日期的时间段
                Expanded(child: _buildTimeSlotsSection()),
              ],
            ),
    );
  }

  /// 构建日期选择器
  Widget _buildDateSelector() {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today,
            size: 24.w,
            color: AppTheme.primaryColor,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '选择日期',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppTheme.textSecondary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  _formatDate(_selectedDate),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton.icon(
            onPressed: _selectDate,
            icon: const Icon(Icons.edit_calendar),
            label: const Text('切换日期'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.primaryColor,
              side: BorderSide(color: AppTheme.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建时间段部分
  Widget _buildTimeSlotsSection() {
    final dateKey = _getDateKey(_selectedDate);
    final slots = _timeSlots[dateKey] ?? [];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '可接单时段',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              OutlinedButton.icon(
                onPressed: _handleAddTimeSlot,
                icon: const Icon(Icons.add),
                label: const Text('添加'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                  side: BorderSide(color: AppTheme.primaryColor),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          if (slots.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.event_busy,
                      size: 64.w,
                      color: AppTheme.textSecondary.withValues(alpha: 0.5),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      '当天暂无可接单时段',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '点击上方"添加"按钮设置时段',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppTheme.textSecondary.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: slots.length,
                itemBuilder: (context, index) {
                  return _buildTimeSlotItem(slots[index]);
                },
              ),
            ),
        ],
      ),
    );
  }

  /// 构建时间段项
  Widget _buildTimeSlotItem(TimeSlot slot) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: slot.isAvailable
            ? AppTheme.successColor.withValues(alpha: 0.1)
            : AppTheme.textSecondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: slot.isAvailable
              ? AppTheme.successColor.withValues(alpha: 0.3)
              : AppTheme.textSecondary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.access_time,
            size: 20.w,
            color:
                slot.isAvailable ? AppTheme.successColor : AppTheme.textSecondary,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${slot.startTime} - ${slot.endTime}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                if (slot.note != null && slot.note!.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    slot.note!,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: slot.isAvailable
                  ? AppTheme.successColor
                  : AppTheme.textSecondary,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              slot.isAvailable ? '可接单' : '已停用',
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          PopupMenuButton<String>(
            onSelected: (value) => _handleTimeSlotAction(value, slot),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined),
                    SizedBox(width: 8),
                    Text('编辑'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'toggle',
                child: Row(
                  children: [
                    Icon(
                      slot.isAvailable
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    const SizedBox(width: 8),
                    Text(slot.isAvailable ? '停用' : '启用'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: Colors.red),
                    SizedBox(width: 8),
                    Text('删除', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 选择日期
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      await _loadSchedule();
    }
  }

  /// 获取日期键值
  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// 格式化日期
  String _formatDate(DateTime date) {
    final weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    final weekday = weekdays[date.weekday - 1];
    return '${date.year}年${date.month}月${date.day}日 $weekday';
  }

  /// 批量设置时段
  void _handleBatchSet() {
    _showBatchSetDialog();
  }

  /// 显示批量设置对话框
  Future<void> _showBatchSetDialog() async {
    DateTimeRange? dateRange;
    List<int> selectedWeekdays = [1, 2, 3, 4, 5]; // 默认工作日
    final List<TimeSlotTemplate> timeSlotTemplates = [];

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('批量设置时段'),
          content: SingleChildScrollView(
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 日期范围选择
                  Text(
                    '选择日期范围',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  InkWell(
                    onTap: () async {
                      final picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 90)),
                        initialDateRange: dateRange,
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: AppTheme.primaryColor,
                                onPrimary: Colors.white,
                                surface: Colors.white,
                                onSurface: AppTheme.textPrimary,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setState(() => dateRange = picked);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.dividerColor),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.date_range, color: AppTheme.primaryColor),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              dateRange != null
                                  ? '${_formatDate(dateRange!.start)} - ${_formatDate(dateRange!.end)}'
                                  : '点击选择日期范围',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: dateRange != null
                                    ? AppTheme.textPrimary
                                    : AppTheme.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // 星期选择
                  Text(
                    '选择星期',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: List.generate(7, (index) {
                      final weekday = index + 1;
                      final weekdayNames = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
                      final isSelected = selectedWeekdays.contains(weekday);

                      return FilterChip(
                        label: Text(weekdayNames[index]),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedWeekdays.add(weekday);
                            } else {
                              selectedWeekdays.remove(weekday);
                            }
                            selectedWeekdays.sort();
                          });
                        },
                        selectedColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                        checkmarkColor: AppTheme.primaryColor,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? AppTheme.primaryColor
                              : AppTheme.textSecondary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 16.h),

                  // 时段模板
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '时段设置',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            timeSlotTemplates.add(TimeSlotTemplate(
                              startTime: const TimeOfDay(hour: 9, minute: 0),
                              endTime: const TimeOfDay(hour: 17, minute: 0),
                              note: '',
                            ));
                          });
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('添加时段'),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),

                  // 时段列表
                  if (timeSlotTemplates.isEmpty)
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Center(
                        child: Text(
                          '点击"添加时段"按钮添加时段',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    )
                  else
                    ...timeSlotTemplates.asMap().entries.map((entry) {
                      final index = entry.key;
                      final template = entry.value;

                      return Container(
                        margin: EdgeInsets.only(bottom: 8.h),
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundColor,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '时段 ${index + 1}',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      timeSlotTemplates.removeAt(index);
                                    });
                                  },
                                  icon: const Icon(Icons.delete_outline),
                                  color: AppTheme.errorColor,
                                  iconSize: 20.w,
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTimeButton(
                                    context: context,
                                    label: '开始',
                                    time: template.startTime,
                                    onTimeChanged: (time) {
                                      setState(() {
                                        timeSlotTemplates[index] = TimeSlotTemplate(
                                          startTime: time,
                                          endTime: template.endTime,
                                          note: template.note,
                                        );
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Icon(Icons.arrow_forward, size: 16.w),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: _buildTimeButton(
                                    context: context,
                                    label: '结束',
                                    time: template.endTime,
                                    onTimeChanged: (time) {
                                      setState(() {
                                        timeSlotTemplates[index] = TimeSlotTemplate(
                                          startTime: template.startTime,
                                          endTime: time,
                                          note: template.note,
                                        );
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: dateRange != null &&
                      selectedWeekdays.isNotEmpty &&
                      timeSlotTemplates.isNotEmpty
                  ? () => Navigator.of(context).pop(true)
                  : null,
              child: const Text('批量设置'),
            ),
          ],
        ),
      ),
    );

    if (result == true && dateRange != null) {
      await _applyBatchSettings(
        dateRange: dateRange!,
        weekdays: selectedWeekdays,
        templates: timeSlotTemplates,
      );
    }
  }

  /// 构建时间选择按钮
  Widget _buildTimeButton({
    required BuildContext context,
    required String label,
    required TimeOfDay time,
    required Function(TimeOfDay) onTimeChanged,
  }) {
    return InkWell(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: time,
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: AppTheme.primaryColor,
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: AppTheme.textPrimary,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          onTimeChanged(picked);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.dividerColor),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                color: AppTheme.textSecondary,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              _formatTimeOfDay(time),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 应用批量设置
  Future<void> _applyBatchSettings({
    required DateTimeRange dateRange,
    required List<int> weekdays,
    required List<TimeSlotTemplate> templates,
  }) async {
    if (templates.isEmpty) return;

    // TODO: 调用 API 批量设置时段
    int addedCount = 0;
    final currentDate = dateRange.start;
    final endDate = dateRange.end;

    // 遍历日期范围
    DateTime date = currentDate;
    while (date.isBefore(endDate) || date.isAtSameMomentAs(endDate)) {
      // 检查是否在选中的星期内
      if (weekdays.contains(date.weekday)) {
        final dateKey = _getDateKey(date);

        // 初始化该日期的时段列表
        if (!_timeSlots.containsKey(dateKey)) {
          _timeSlots[dateKey] = [];
        }

        // 添加所有时段模板
        for (final template in templates) {
          // 验证时间范围
          if (!_isTimeAfter(template.startTime, template.endTime)) {
            _timeSlots[dateKey]!.add(TimeSlot(
              id: '${DateTime.now().millisecondsSinceEpoch}_${addedCount}',
              startTime: _formatTimeOfDay(template.startTime),
              endTime: _formatTimeOfDay(template.endTime),
              note: template.note,
              isAvailable: true,
            ));
            addedCount++;
          }
        }
      }

      date = date.add(const Duration(days: 1));
    }

    if (mounted) {
      setState(() {});

      final daysCount = dateRange.duration.inDays + 1;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('批量设置成功！共为 $daysCount 天添加了 $addedCount 个时段'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  /// 添加时间段
  void _handleAddTimeSlot() {
    _showTimeSlotDialog();
  }

  /// 显示时间段对话框
  Future<void> _showTimeSlotDialog({TimeSlot? slot}) async {
    TimeOfDay startTime = slot != null
        ? _parseTimeOfDay(slot.startTime)
        : const TimeOfDay(hour: 9, minute: 0);
    TimeOfDay endTime = slot != null
        ? _parseTimeOfDay(slot.endTime)
        : const TimeOfDay(hour: 17, minute: 0);
    final noteController = TextEditingController(text: slot?.note ?? '');
    bool isAvailable = slot?.isAvailable ?? true;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(slot == null ? '添加时段' : '编辑时段'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 开始时间
                Text(
                  '开始时间',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                InkWell(
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: startTime,
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: AppTheme.primaryColor,
                              onPrimary: Colors.white,
                              surface: Colors.white,
                              onSurface: AppTheme.textPrimary,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      setState(() => startTime = picked);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.dividerColor),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.access_time, color: AppTheme.primaryColor),
                        SizedBox(width: 12.w),
                        Text(
                          _formatTimeOfDay(startTime),
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                // 结束时间
                Text(
                  '结束时间',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                InkWell(
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: endTime,
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: AppTheme.primaryColor,
                              onPrimary: Colors.white,
                              surface: Colors.white,
                              onSurface: AppTheme.textPrimary,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      setState(() => endTime = picked);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.dividerColor),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.access_time, color: AppTheme.primaryColor),
                        SizedBox(width: 12.w),
                        Text(
                          _formatTimeOfDay(endTime),
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                // 备注
                Text(
                  '备注（可选）',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                TextField(
                  controller: noteController,
                  decoration: InputDecoration(
                    hintText: '例如：仅限周末',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  maxLines: 2,
                ),
                SizedBox(height: 16.h),

                // 状态开关
                Row(
                  children: [
                    Text(
                      '启用该时段',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    Switch(
                      value: isAvailable,
                      onChanged: (value) {
                        setState(() => isAvailable = value);
                      },
                      activeTrackColor: AppTheme.successColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop({
                  'startTime': startTime,
                  'endTime': endTime,
                  'note': noteController.text.trim(),
                  'isAvailable': isAvailable,
                });
              },
              child: Text(slot == null ? '添加' : '保存'),
            ),
          ],
        ),
      ),
    );

    if (result != null) {
      final startTimeStr = _formatTimeOfDay(result['startTime'] as TimeOfDay);
      final endTimeStr = _formatTimeOfDay(result['endTime'] as TimeOfDay);

      // 验证时间范围
      if (_isTimeAfter(result['startTime'] as TimeOfDay, result['endTime'] as TimeOfDay)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('结束时间必须晚于开始时间')),
          );
        }
        return;
      }

      if (slot == null) {
        // 添加新时段
        // TODO: 调用 API 添加时段
        final dateKey = _getDateKey(_selectedDate);
        if (!_timeSlots.containsKey(dateKey)) {
          _timeSlots[dateKey] = [];
        }
        _timeSlots[dateKey]!.add(TimeSlot(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          startTime: startTimeStr,
          endTime: endTimeStr,
          note: result['note'] as String,
          isAvailable: result['isAvailable'] as bool,
        ));

        if (mounted) {
          setState(() {});
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('时段添加成功')),
          );
        }
      } else {
        // 编辑时段
        // TODO: 调用 API 更新时段
        final dateKey = _getDateKey(_selectedDate);
        final index = _timeSlots[dateKey]?.indexWhere((s) => s.id == slot.id) ?? -1;
        if (index != -1) {
          _timeSlots[dateKey]![index] = TimeSlot(
            id: slot.id,
            startTime: startTimeStr,
            endTime: endTimeStr,
            note: result['note'] as String,
            isAvailable: result['isAvailable'] as bool,
          );

          if (mounted) {
            setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('时段更新成功')),
            );
          }
        }
      }
    }

    noteController.dispose();
  }

  /// 解析时间字符串为 TimeOfDay
  TimeOfDay _parseTimeOfDay(String timeStr) {
    final parts = timeStr.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  /// 格式化 TimeOfDay 为字符串
  String _formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  /// 判断时间1是否晚于时间2
  bool _isTimeAfter(TimeOfDay time1, TimeOfDay time2) {
    return time1.hour > time2.hour ||
           (time1.hour == time2.hour && time1.minute >= time2.minute);
  }

  /// 处理时间段操作
  void _handleTimeSlotAction(String action, TimeSlot slot) {
    switch (action) {
      case 'edit':
        _showTimeSlotDialog(slot: slot);
        break;
      case 'toggle':
        _handleToggleTimeSlot(slot);
        break;
      case 'delete':
        _handleDeleteTimeSlot(slot);
        break;
    }
  }

  /// 切换时间段状态
  Future<void> _handleToggleTimeSlot(TimeSlot slot) async {
    // TODO: 调用 API 切换时段状态
    final dateKey = _getDateKey(_selectedDate);
    final index = _timeSlots[dateKey]?.indexWhere((s) => s.id == slot.id) ?? -1;

    if (index != -1) {
      setState(() {
        _timeSlots[dateKey]![index] = TimeSlot(
          id: slot.id,
          startTime: slot.startTime,
          endTime: slot.endTime,
          note: slot.note,
          isAvailable: !slot.isAvailable,
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(slot.isAvailable ? '已停用时段' : '已启用时段'),
        ),
      );
    }
  }

  /// 删除时间段
  Future<void> _handleDeleteTimeSlot(TimeSlot slot) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除时段 ${slot.startTime} - ${slot.endTime} 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // TODO: 调用 API 删除时间段
      final dateKey = _getDateKey(_selectedDate);
      final index = _timeSlots[dateKey]?.indexWhere((s) => s.id == slot.id) ?? -1;

      if (index != -1) {
        setState(() {
          _timeSlots[dateKey]!.removeAt(index);
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('删除成功')),
          );
        }
      }
    }
  }
}

/// 时间段模型
class TimeSlot {
  final String id;
  final String startTime;
  final String endTime;
  final bool isAvailable;
  final String? note;

  TimeSlot({
    required this.id,
    required this.startTime,
    required this.endTime,
    this.isAvailable = true,
    this.note,
  });
}

/// 时间段模板（用于批量设置）
class TimeSlotTemplate {
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String note;

  TimeSlotTemplate({
    required this.startTime,
    required this.endTime,
    this.note = '',
  });
}
