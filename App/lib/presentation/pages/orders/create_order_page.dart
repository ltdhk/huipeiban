import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../app/theme.dart';
import '../../../data/models/companion.dart';
import '../../../data/models/institution.dart';
import '../../../data/models/patient.dart';
import '../../../data/models/service.dart';
import '../../../data/repositories/patient_repository.dart';
import '../../../data/repositories/companion_repository.dart';
import '../../../data/repositories/order_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/ai_chat_controller.dart';

/// 订单创建页面
class CreateOrderPage extends StatefulWidget {
  final Companion? companion;
  final Institution? institution;
  final Map<String, dynamic>? aiContext; // AI 对话中收集的信息

  const CreateOrderPage({
    super.key,
    this.companion,
    this.institution,
    this.aiContext,
  }) : assert(companion != null || institution != null, '必须提供陪诊师或机构');

  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  // 仓库
  final _patientRepository = PatientRepository();
  final _companionRepository = CompanionRepository();

  // 从 AI 上下文获取的信息
  String? _hospitalName;
  String? _department;
  DateTime? _appointmentDate;
  TimeOfDay? _appointmentTime;

  // 用户选择的信息
  Patient? _selectedPatient;
  ServiceSpec? _selectedServiceSpec;
  String _selectedPickup = 'none'; // none, pickup_only, dropoff_only, both

  // 数据加载状态
  bool _isLoadingPatients = true;
  bool _isLoadingServices = true;
  List<Patient> _patients = [];
  List<Service> _services = [];

  @override
  void initState() {
    super.initState();
    _initializeFromContext();
    _loadData();
  }

  /// 加载所有数据
  Future<void> _loadData() async {
    await Future.wait([
      _loadPatients(),
      _loadServices(),
    ]);
  }

  /// 从 API 加载就诊人列表
  Future<void> _loadPatients() async {
    try {
      setState(() {
        _isLoadingPatients = true;
      });

      final patients = await _patientRepository.getPatients();

      setState(() {
        _patients = patients;
        _isLoadingPatients = false;

        // 选择默认就诊人
        if (patients.isNotEmpty) {
          _selectedPatient = patients.firstWhere(
            (p) => p.isDefault,
            orElse: () => patients.first,
          );
        }
      });
    } catch (e) {
      setState(() {
        _isLoadingPatients = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载就诊人列表失败: $e')),
        );
      }
    }
  }

  /// 从 API 加载服务包列表
  Future<void> _loadServices() async {
    // 如果是机构订单，暂时跳过加载服务（机构有自己的服务列表）
    if (widget.companion == null) {
      setState(() {
        _isLoadingServices = false;
      });
      return;
    }

    try {
      setState(() {
        _isLoadingServices = true;
      });

      final detail = await _companionRepository.getCompanionDetail(widget.companion!.id);

      setState(() {
        _services = detail.services;
        _isLoadingServices = false;

        // 选择默认服务规格（第一个服务的第一个规格）
        if (_services.isNotEmpty && _services.first.specs != null && _services.first.specs!.isNotEmpty) {
          _selectedServiceSpec = _services.first.specs!.first;
        }
      });
    } catch (e) {
      setState(() {
        _isLoadingServices = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载服务列表失败: $e')),
        );
      }
    }
  }

  /// 从 AI 上下文初始化信息
  void _initializeFromContext() {
    debugPrint('CreateOrderPage - 接收到的 aiContext: ${widget.aiContext}');

    if (widget.aiContext != null) {
      _hospitalName = widget.aiContext!['hospital'] as String?;
      _department = widget.aiContext!['department'] as String?;

      debugPrint('从 aiContext 提取 - hospital: $_hospitalName, department: $_department');

      // 解析日期和时间
      final dateStr = widget.aiContext!['date'] as String?;
      if (dateStr != null) {
        try {
          _appointmentDate = DateTime.parse(dateStr);
        } catch (e) {
          // 解析失败
        }
      }

      final timeStr = widget.aiContext!['time'] as String?;
      if (timeStr != null) {
        try {
          final parts = timeStr.split(':');
          _appointmentTime = TimeOfDay(
            hour: int.parse(parts[0]),
            minute: int.parse(parts[1]),
          );
        } catch (e) {
          // 解析失败
        }
      }
    }

    // 默认值
    _hospitalName ??= '北京协和医院';
    _appointmentDate ??= DateTime.now().add(const Duration(days: 1));
    _appointmentTime ??= const TimeOfDay(hour: 9, minute: 30);

    debugPrint('最终设置 - hospital: $_hospitalName, date: $_appointmentDate, time: $_appointmentTime');
  }

  /// 获取服务包价格
  double _getPackagePrice() {
    return _selectedServiceSpec?.price ?? 0.0;
  }

  /// 获取接送服务价格
  double _getPickupPrice() {
    switch (_selectedPickup) {
      case 'pickup_only':
      case 'dropoff_only':
        return 50.0;
      case 'both':
        return 80.0;
      default:
        return 0.0;
    }
  }

  /// 计算总价
  double _getTotalPrice() {
    return _getPackagePrice() + _getPickupPrice();
  }

  /// 获取服务包描述（用于底部价格显示）
  String _getPackageDuration() {
    if (_selectedServiceSpec != null) {
      return '${_selectedServiceSpec!.durationHours}小时';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('服务详情'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 服务类型卡片
                  _buildServiceCard(),
                  SizedBox(height: 16.h),

                  // 陪诊师信息
                  _buildCompanionCard(),
                  SizedBox(height: 16.h),

                  // 服务地点
                  _buildHospitalCard(),
                  SizedBox(height: 16.h),

                  // 服务时间
                  _buildDateTimeCard(),
                  SizedBox(height: 16.h),

                  // 选择就诊人
                  _buildPatientSection(),
                  SizedBox(height: 16.h),

                  // 服务规格
                  _buildPackageSection(),
                  SizedBox(height: 16.h),

                  // 是否接送
                  _buildPickupSection(),
                  SizedBox(height: 16.h),

                  // 项目介绍
                  _buildIntroductionSection(),
                ],
              ),
            ),
          ),

          // 底部价格和预约按钮
          _buildBottomBar(),
        ],
      ),
    );
  }

  /// 构建服务类型卡片
  Widget _buildServiceCard() {
    return Container(
      width: double.infinity,
      height: 120.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=400',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.3),
              Colors.black.withOpacity(0.6),
            ],
          ),
        ),
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '全程陪诊',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                _buildBadge('买务认证', Icons.verified_outlined),
                SizedBox(width: 8.w),
                _buildBadge('担保交易', Icons.shield_outlined),
                SizedBox(width: 8.w),
                _buildBadge('过单绝保', Icons.security_outlined),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String label, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.w, color: Colors.white),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建陪诊师/机构卡片
  Widget _buildCompanionCard() {
    // 判断是陪诊师还是机构
    final isCompanion = widget.companion != null;
    final name = isCompanion ? widget.companion!.name : widget.institution!.name;
    final avatarUrl = isCompanion ? widget.companion!.avatarUrl : widget.institution!.logoUrl;
    final rating = isCompanion ? widget.companion!.rating : widget.institution!.rating;
    final completedOrders = isCompanion ? widget.companion!.completedOrders : widget.institution!.completedOrders;
    final label = isCompanion ? '金牌陪诊师' : '认证机构';

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          // 头像/Logo
          if (isCompanion)
            CircleAvatar(
              radius: 28.w,
              backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
              backgroundImage: avatarUrl != null &&
                      (avatarUrl.startsWith('http://') ||
                          avatarUrl.startsWith('https://'))
                  ? NetworkImage(avatarUrl)
                  : null,
              child: avatarUrl == null ||
                      !(avatarUrl.startsWith('http://') ||
                          avatarUrl.startsWith('https://'))
                  ? Icon(Icons.person, size: 28.w, color: AppTheme.primaryColor)
                  : null,
            )
          else
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: avatarUrl != null &&
                      (avatarUrl.startsWith('http://') ||
                          avatarUrl.startsWith('https://'))
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.network(avatarUrl, fit: BoxFit.cover),
                    )
                  : Icon(Icons.business, size: 28.w, color: AppTheme.primaryColor),
            ),
          SizedBox(width: 12.w),

          // 信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(Icons.star, size: 14.w, color: Colors.amber),
                    SizedBox(width: 4.w),
                    Text(
                      rating.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      '(${completedOrders}次服务)',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 聊天按钮
          IconButton(
            icon: Icon(Icons.chat_bubble_outline, color: AppTheme.primaryColor),
            onPressed: () {
              // TODO: 打开聊天
            },
          ),
        ],
      ),
    );
  }

  /// 构建医院卡片（可编辑）
  Widget _buildHospitalCard() {
    return GestureDetector(
      onTap: _editHospital,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(Icons.location_on, color: AppTheme.primaryColor, size: 24.w),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '服务地点',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    _hospitalName ?? '',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.edit, color: AppTheme.textSecondary, size: 20.w),
          ],
        ),
      ),
    );
  }

  /// 编辑医院
  void _editHospital() async {
    final controller = TextEditingController(text: _hospitalName);

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('编辑服务地点'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: '请输入医院名称',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('确定'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _hospitalName = result;
      });
    }
  }

  /// 构建日期时间卡片（可编辑）
  Widget _buildDateTimeCard() {
    final dateStr = _appointmentDate != null
        ? DateFormat('yyyy年M月d日').format(_appointmentDate!)
        : '';
    final timeStr = _appointmentTime != null
        ? '${_appointmentTime!.hour.toString().padLeft(2, '0')}:${_appointmentTime!.minute.toString().padLeft(2, '0')}'
        : '';

    return GestureDetector(
      onTap: _editDateTime,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: AppTheme.primaryColor, size: 24.w),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '服务时间',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '$dateStr $timeStr',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.edit, color: AppTheme.textSecondary, size: 20.w),
          ],
        ),
      ),
    );
  }

  /// 编辑日期和时间
  void _editDateTime() async {
    // 先选择日期
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _appointmentDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (selectedDate == null) return;

    // 再选择时间
    if (!mounted) return;
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: _appointmentTime ?? const TimeOfDay(hour: 9, minute: 0),
    );

    if (selectedTime == null) return;

    setState(() {
      _appointmentDate = selectedDate;
      _appointmentTime = selectedTime;
    });
  }

  /// 构建就诊人选择部分
  Widget _buildPatientSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '选择就诊人',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        if (_isLoadingPatients)
          const Center(child: CircularProgressIndicator())
        else if (_patients.isEmpty)
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: const Text('暂无就诊人，请先添加'),
          )
        else
          ..._patients.map((patient) => _buildPatientCard(patient)),
        SizedBox(height: 8.h),
        _buildAddPatientButton(),
      ],
    );
  }

  Widget _buildPatientCard(Patient patient) {
    final isSelected = _selectedPatient?.id == patient.id;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPatient = patient;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.dividerColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.account_circle,
              size: 32.w,
              color: isSelected
                  ? AppTheme.primaryColor
                  : AppTheme.textSecondary,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient.name,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    patient.phone ?? '',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppTheme.primaryColor,
                size: 24.w,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddPatientButton() {
    return GestureDetector(
      onTap: _addPatient,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppTheme.dividerColor,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              color: AppTheme.primaryColor,
              size: 20.w,
            ),
            SizedBox(width: 8.w),
            Text(
              '添加就诊人',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 添加就诊人
  void _addPatient() async {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    String selectedGender = 'male';
    String selectedRelationship = 'self';

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('添加就诊人'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: '姓名 *',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.h),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: '手机号',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 16.h),
                DropdownButtonFormField<String>(
                  value: selectedGender,
                  decoration: const InputDecoration(
                    labelText: '性别 *',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'male', child: Text('男')),
                    DropdownMenuItem(value: 'female', child: Text('女')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedGender = value);
                    }
                  },
                ),
                SizedBox(height: 16.h),
                DropdownButtonFormField<String>(
                  value: selectedRelationship,
                  decoration: const InputDecoration(
                    labelText: '关系 *',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'self', child: Text('本人')),
                    DropdownMenuItem(value: 'parent', child: Text('父母')),
                    DropdownMenuItem(value: 'child', child: Text('子女')),
                    DropdownMenuItem(value: 'spouse', child: Text('配偶')),
                    DropdownMenuItem(value: 'other', child: Text('其他')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedRelationship = value);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('请输入姓名')),
                  );
                  return;
                }
                Navigator.pop(context, true);
              },
              child: const Text('确定'),
            ),
          ],
        ),
      ),
    );

    if (result == true) {
      try {
        await _patientRepository.createPatient({
          'name': nameController.text,
          'gender': selectedGender,
          if (phoneController.text.isNotEmpty) 'phone': phoneController.text,
          'relationship': selectedRelationship,
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('添加成功')),
          );

          // 重新加载就诊人列表
          await _loadPatients();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('添加失败: $e')),
          );
        }
      }
    }
  }

  /// 构建服务规格部分
  Widget _buildPackageSection() {
    if (_isLoadingServices) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_services.isEmpty) {
      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: const Text('暂无服务包信息'),
      );
    }

    // 获取所有服务规格
    final List<ServiceSpec> allSpecs = [];
    for (final service in _services) {
      if (service.specs != null) {
        allSpecs.addAll(service.specs!);
      }
    }

    if (allSpecs.isEmpty) {
      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: const Text('暂无服务规格'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '服务规格',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        // 构建服务规格网格（2列）
        ...List.generate((allSpecs.length / 2).ceil(), (rowIndex) {
          final startIndex = rowIndex * 2;
          final endIndex = (startIndex + 2).clamp(0, allSpecs.length);
          final rowSpecs = allSpecs.sublist(startIndex, endIndex);

          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Row(
              children: [
                ...rowSpecs.map((spec) {
                  final index = allSpecs.indexOf(spec);
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: index % 2 == 0 && index < allSpecs.length - 1 ? 12.w : 0,
                      ),
                      child: _buildServiceSpecOption(spec),
                    ),
                  );
                }),
                // 如果这一行只有一个元素，添加一个空的Expanded来保持布局
                if (rowSpecs.length == 1) const Expanded(child: SizedBox()),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildServiceSpecOption(ServiceSpec spec) {
    final isSelected = _selectedServiceSpec?.id == spec.id;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedServiceSpec = spec;
        });
      },
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withValues(alpha: 0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.dividerColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              spec.name,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimary,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              spec.description ?? '${spec.durationHours}小时服务',
              style: TextStyle(
                fontSize: 11.sp,
                color: AppTheme.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.h),
            Text(
              '¥${spec.price.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppTheme.primaryColor : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建接送选择部分
  Widget _buildPickupSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '是否接送',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            _buildPickupOption('只接', 'pickup_only'),
            SizedBox(width: 8.w),
            _buildPickupOption('只送', 'dropoff_only'),
            SizedBox(width: 8.w),
            _buildPickupOption('接送', 'both'),
            SizedBox(width: 8.w),
            _buildPickupOption('否', 'none'),
          ],
        ),
      ],
    );
  }

  Widget _buildPickupOption(String label, String value) {
    final isSelected = _selectedPickup == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPickup = value;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primaryColor
                : Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isSelected ? AppTheme.primaryColor : AppTheme.dividerColor,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: isSelected ? Colors.white : AppTheme.textPrimary,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  /// 构建项目介绍部分
  Widget _buildIntroductionSection() {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: AppTheme.textSecondary,
            indicatorColor: AppTheme.primaryColor,
            labelStyle: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
            tabs: const [
              Tab(text: '项目介绍'),
              Tab(text: '下单须知'),
            ],
          ),
          SizedBox(
            height: 200.h,
            child: TabBarView(
              children: [
                _buildIntroductionTab(),
                _buildNoticeTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroductionTab() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: SingleChildScrollView(
        child: Text(
          '我们的"全程陪诊"服务旨在为您提供从家到医院、再从医院回家门的全程无忧陪伴。服务内容包括但不限于：\n\n'
          '• 就诊前的提醒与准备\n'
          '• 交通安排、医院内的引导\n'
          '• 挂号、排号、缴费、检查\n'
          '• 与医生沟通、取药、问询检查\n'
          '• 以及就诊后的情况反馈\n\n'
          '我们的专业陪诊师确保您在就诊过程中的每个环节都能感到安心、省心、放心。',
          style: TextStyle(
            fontSize: 13.sp,
            color: AppTheme.textSecondary,
            height: 1.6,
          ),
        ),
      ),
    );
  }

  Widget _buildNoticeTab() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: SingleChildScrollView(
        child: Text(
          '下单前请注意：\n\n'
          '1. 请确保预约时间准确无误\n'
          '2. 如需接送服务，请提前设置好地址\n'
          '3. 特殊需求请在备注中说明\n'
          '4. 取消订单需提前24小时\n'
          '5. 如有疑问请联系客服',
          style: TextStyle(
            fontSize: 13.sp,
            color: AppTheme.textSecondary,
            height: 1.6,
          ),
        ),
      ),
    );
  }

  /// 构建底部价格栏
  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '¥',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _getTotalPrice().toStringAsFixed(0),
                        style: TextStyle(
                          fontSize: 28.sp,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_selectedServiceSpec != null)
                        Text(
                          ' /${_selectedServiceSpec!.durationHours}小时',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            ElevatedButton(
              onPressed: _handleCreateOrder,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(140.w, 48.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
              ),
              child: Text(
                '一键预约',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 处理创建订单 - 直接创建预约订单，跳过支付
  Future<void> _handleCreateOrder() async {
    // 验证必填项
    if (_selectedPatient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请选择就诊人')),
      );
      return;
    }

    // 机构订单可以不选服务规格
    if (widget.companion != null && _selectedServiceSpec == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请选择服务套餐')),
      );
      return;
    }

    if (_hospitalName == null || _hospitalName!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入医院名称')),
      );
      return;
    }

    if (_appointmentDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请选择预约日期')),
      );
      return;
    }

    if (_appointmentTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请选择预约时间')),
      );
      return;
    }

    // 计算价格
    final servicePrice = _selectedServiceSpec?.price ?? 200.0; // 默认价格
    final pickupPrice = _selectedPickup != 'none' ? 50.0 : 0.0; // 接送费用固定50元
    final totalPrice = servicePrice + pickupPrice;

    // 格式化预约时间
    final appointmentTimeStr = '${_appointmentTime!.hour.toString().padLeft(2, '0')}:${_appointmentTime!.minute.toString().padLeft(2, '0')}';

    // 显示加载对话框
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              SizedBox(height: 16.h),
              Text(
                '正在创建预约订单...',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      final orderRepository = OrderRepository();

      // 判断订单类型
      final isCompanion = widget.companion != null;
      final orderType = isCompanion ? 'companion' : 'institution';

      // 调用后端 API 创建订单
      final result = await orderRepository.createOrder(
        patientId: _selectedPatient!.id,
        orderType: orderType,
        companionId: isCompanion ? widget.companion!.id : null,
        institutionId: !isCompanion ? widget.institution!.id : null,
        serviceSpecId: _selectedServiceSpec?.id,
        hospitalName: _hospitalName!,
        department: _department,
        appointmentDate: _appointmentDate!,
        appointmentTime: appointmentTimeStr,
        needPickup: _selectedPickup != 'none',
        servicePrice: servicePrice,
        pickupPrice: pickupPrice,
      );

      // 获取订单信息
      final orderId = result['order_id'] as int;
      final orderNo = result['order_no'] as String;

      // 关闭加载对话框
      if (mounted) {
        Navigator.of(context).pop();

        // 跳转到预约成功页面，传入 orderId 用于后续获取完整订单数据
        Navigator.of(context).pushReplacementNamed(
          '/booking-success',
          arguments: {
            'orderId': orderId,
            'orderNo': orderNo,
            'amount': totalPrice,
          },
        );
      }
    } catch (e) {
      // 关闭加载对话框
      if (mounted) {
        Navigator.of(context).pop();

        // 显示错误提示
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('创建订单失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
