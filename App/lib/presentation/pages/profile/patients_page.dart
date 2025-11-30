import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/theme.dart';
import '../../../data/models/patient.dart';
import '../../controllers/patient_controller.dart';

/// 就诊人管理页面
class PatientsPage extends ConsumerStatefulWidget {
  const PatientsPage({super.key});

  @override
  ConsumerState<PatientsPage> createState() => _PatientsPageState();
}

class _PatientsPageState extends ConsumerState<PatientsPage> {
  @override
  void initState() {
    super.initState();
    // 加载就诊人列表
    Future.microtask(() {
      ref.read(patientControllerProvider.notifier).loadPatients();
    });
  }

  @override
  Widget build(BuildContext context) {
    final patientsState = ref.watch(patientControllerProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('就诊人管理'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddEditDialog(context),
            tooltip: '添加就诊人',
          ),
        ],
      ),
      body: patientsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48.w,
                color: AppTheme.errorColor,
              ),
              SizedBox(height: 16.h),
              Text(
                '加载失败',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppTheme.textSecondary,
                ),
              ),
              SizedBox(height: 8.h),
              TextButton(
                onPressed: () {
                  ref.read(patientControllerProvider.notifier).loadPatients();
                },
                child: const Text('重试'),
              ),
            ],
          ),
        ),
        data: (patients) {
          if (patients.isEmpty) {
            return _buildEmptyState();
          }
          return _buildPatientList(patients);
        },
      ),
    );
  }

  /// 构建空状态
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 72.w,
            color: AppTheme.textHint,
          ),
          SizedBox(height: 16.h),
          Text(
            '暂无就诊人',
            style: TextStyle(
              fontSize: 18.sp,
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '添加就诊人后可以更快速地预约服务',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppTheme.textHint,
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: () => _showAddEditDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('添加就诊人'),
          ),
        ],
      ),
    );
  }

  /// 构建就诊人列表
  Widget _buildPatientList(List<Patient> patients) {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: patients.length,
      itemBuilder: (context, index) {
        final patient = patients[index];
        return _buildPatientCard(patient);
      },
    );
  }

  /// 构建就诊人卡片
  Widget _buildPatientCard(Patient patient) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showAddEditDialog(context, patient: patient),
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // 头像
                    Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Icon(
                        patient.gender == 'male'
                            ? Icons.male
                            : patient.gender == 'female'
                                ? Icons.female
                                : Icons.person_outline,
                        size: 24.w,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    SizedBox(width: 12.w),

                    // 姓名和关系
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                patient.name,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  _getRelationshipText(patient.relationship),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                              ),
                              if (patient.isDefault) ...[
                                SizedBox(width: 8.w),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 2.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.successColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  child: Text(
                                    '默认',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppTheme.successColor,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '${_getGenderText(patient.gender)} · ${_calculateAge(patient.birthDate)}岁',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 操作按钮
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        color: AppTheme.textHint,
                      ),
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            _showAddEditDialog(context, patient: patient);
                            break;
                          case 'default':
                            _setDefaultPatient(patient);
                            break;
                          case 'delete':
                            _showDeleteConfirm(patient);
                            break;
                        }
                      },
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
                        if (!patient.isDefault)
                          const PopupMenuItem(
                            value: 'default',
                            child: Row(
                              children: [
                                Icon(Icons.check_circle_outline),
                                SizedBox(width: 8),
                                Text('设为默认'),
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

                // 手机号
                if (patient.phone != null && patient.phone!.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        size: 16.w,
                        color: AppTheme.textHint,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        patient.phone!,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 显示添加/编辑对话框
  void _showAddEditDialog(BuildContext context, {Patient? patient}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientEditPage(patient: patient),
      ),
    );
  }

  /// 设置默认就诊人
  Future<void> _setDefaultPatient(Patient patient) async {
    try {
      await ref.read(patientControllerProvider.notifier).setDefault(patient.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('已设为默认就诊人')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('设置失败: $e')),
        );
      }
    }
  }

  /// 显示删除确认
  void _showDeleteConfirm(Patient patient) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除就诊人 ${patient.name} 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref.read(patientControllerProvider.notifier).delete(patient.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('删除成功')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('删除失败: $e')),
                  );
                }
              }
            },
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  /// 获取关系文本
  String _getRelationshipText(String relationship) {
    switch (relationship) {
      case 'self':
        return '本人';
      case 'parent':
        return '父母';
      case 'spouse':
        return '配偶';
      case 'child':
        return '子女';
      case 'other':
        return '其他';
      default:
        return relationship;
    }
  }

  /// 获取性别文本
  String _getGenderText(String gender) {
    switch (gender) {
      case 'male':
        return '男';
      case 'female':
        return '女';
      default:
        return '未知';
    }
  }

  /// 计算年龄
  int _calculateAge(String? birthDate) {
    if (birthDate == null || birthDate.isEmpty) return 0;
    try {
      final birth = DateTime.parse(birthDate);
      final today = DateTime.now();
      int age = today.year - birth.year;
      if (today.month < birth.month ||
          (today.month == birth.month && today.day < birth.day)) {
        age--;
      }
      return age;
    } catch (e) {
      return 0;
    }
  }
}

/// 就诊人编辑页面
class PatientEditPage extends ConsumerStatefulWidget {
  final Patient? patient;

  const PatientEditPage({super.key, this.patient});

  @override
  ConsumerState<PatientEditPage> createState() => _PatientEditPageState();
}

class _PatientEditPageState extends ConsumerState<PatientEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _idCardController;
  late TextEditingController _medicalHistoryController;
  late TextEditingController _allergiesController;

  String _gender = 'male';
  String _relationship = 'self';
  DateTime? _birthDate;
  bool _isDefault = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.patient?.name);
    _phoneController = TextEditingController(text: widget.patient?.phone);
    _idCardController = TextEditingController(text: widget.patient?.idCard);
    _medicalHistoryController = TextEditingController(text: widget.patient?.medicalHistory);
    _allergiesController = TextEditingController(text: widget.patient?.allergies);

    if (widget.patient != null) {
      _gender = widget.patient!.gender.isNotEmpty ? widget.patient!.gender : 'male';
      _relationship = widget.patient!.relationship.isNotEmpty ? widget.patient!.relationship : 'self';
      _isDefault = widget.patient!.isDefault;
      if (widget.patient!.birthDate != null && widget.patient!.birthDate!.isNotEmpty) {
        try {
          _birthDate = DateTime.parse(widget.patient!.birthDate!);
        } catch (e) {
          _birthDate = null;
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _idCardController.dispose();
    _medicalHistoryController.dispose();
    _allergiesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.patient != null;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(isEdit ? '编辑就诊人' : '添加就诊人'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.w),
          children: [
            // 基本信息卡片
            _buildSection(
              title: '基本信息',
              children: [
                _buildTextField(
                  controller: _nameController,
                  label: '姓名',
                  hint: '请输入就诊人姓名',
                  required: true,
                ),
                SizedBox(height: 16.h),

                // 性别选择
                _buildGenderSelector(),
                SizedBox(height: 16.h),

                // 出生日期
                _buildDatePicker(),
                SizedBox(height: 16.h),

                // 与本人关系
                _buildRelationshipSelector(),
                SizedBox(height: 16.h),

                _buildTextField(
                  controller: _phoneController,
                  label: '手机号',
                  hint: '请输入手机号',
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // 健康信息卡片
            _buildSection(
              title: '健康信息（选填）',
              children: [
                _buildTextField(
                  controller: _medicalHistoryController,
                  label: '病史',
                  hint: '请输入既往病史',
                  maxLines: 3,
                ),
                SizedBox(height: 16.h),
                _buildTextField(
                  controller: _allergiesController,
                  label: '过敏史',
                  hint: '请输入过敏史',
                  maxLines: 2,
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // 保存按钮
            ElevatedButton(
              onPressed: _isLoading ? null : _save,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14.h),
              ),
              child: _isLoading
                  ? SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(isEdit ? '保存' : '添加'),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建分区
  Widget _buildSection({required String title, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          Divider(height: 1, color: AppTheme.dividerColor),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  /// 构建文本输入框
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    bool required = false,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      validator: required
          ? (value) {
              if (value == null || value.isEmpty) {
                return '请输入$label';
              }
              return null;
            }
          : null,
    );
  }

  /// 构建性别选择器
  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '性别 *',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppTheme.textSecondary,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: _buildGenderOption('male', '男', Icons.male),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildGenderOption('female', '女', Icons.female),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderOption(String value, String label, IconData icon) {
    final isSelected = _gender == value;
    return GestureDetector(
      onTap: () => setState(() => _gender = value),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.dividerColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建日期选择器
  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '出生日期',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppTheme.textSecondary,
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _birthDate ?? DateTime(2000),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (date != null) {
              setState(() => _birthDate = date);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.dividerColor),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _birthDate != null
                        ? '${_birthDate!.year}-${_birthDate!.month.toString().padLeft(2, '0')}-${_birthDate!.day.toString().padLeft(2, '0')}'
                        : '请选择出生日期',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: _birthDate != null ? AppTheme.textPrimary : AppTheme.textHint,
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_today_outlined,
                  color: AppTheme.textHint,
                  size: 20.w,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 构建关系选择器
  Widget _buildRelationshipSelector() {
    final relationships = [
      ('self', '本人'),
      ('parent', '父母'),
      ('spouse', '配偶'),
      ('child', '子女'),
      ('other', '其他'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '与本人关系 *',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppTheme.textSecondary,
          ),
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: relationships.map((r) {
            final isSelected = _relationship == r.$1;
            return GestureDetector(
              onTap: () => setState(() => _relationship = r.$1),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isSelected ? AppTheme.primaryColor : AppTheme.dividerColor,
                  ),
                ),
                child: Text(
                  r.$2,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isSelected ? Colors.white : AppTheme.textSecondary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// 保存
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final data = {
        'name': _nameController.text,
        'gender': _gender,
        'relationship': _relationship,
        if (_birthDate != null)
          'birth_date': '${_birthDate!.year}-${_birthDate!.month.toString().padLeft(2, '0')}-${_birthDate!.day.toString().padLeft(2, '0')}',
        if (_phoneController.text.isNotEmpty) 'phone': _phoneController.text,
        if (_idCardController.text.isNotEmpty) 'id_card': _idCardController.text,
        if (_medicalHistoryController.text.isNotEmpty) 'medical_history': _medicalHistoryController.text,
        if (_allergiesController.text.isNotEmpty) 'allergies': _allergiesController.text,
      };

      if (widget.patient != null) {
        await ref.read(patientControllerProvider.notifier).updatePatient(widget.patient!.id, data);
      } else {
        await ref.read(patientControllerProvider.notifier).create(data);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.patient != null ? '保存成功' : '添加成功')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存失败: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
