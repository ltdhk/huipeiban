import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/theme.dart';
import '../../../data/models/service.dart';

/// 添加/编辑服务页面
class AddServicePage extends ConsumerStatefulWidget {
  final Service? service;

  const AddServicePage({
    super.key,
    this.service,
  });

  @override
  ConsumerState<AddServicePage> createState() => _AddServicePageState();
}

class _AddServicePageState extends ConsumerState<AddServicePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _basePriceController = TextEditingController();
  final _additionalHourPriceController = TextEditingController();

  final List<String> _features = [];
  final _featureController = TextEditingController();
  final List<ServiceSpecData> _specs = [];
  bool _isActive = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.service != null) {
      _initializeFromService(widget.service!);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    _basePriceController.dispose();
    _additionalHourPriceController.dispose();
    _featureController.dispose();
    super.dispose();
  }

  /// 从已有服务初始化表单
  void _initializeFromService(Service service) {
    _titleController.text = service.title;
    _categoryController.text = service.category ?? '';
    _descriptionController.text = service.description ?? '';
    _basePriceController.text = service.basePrice.toStringAsFixed(0);
    _additionalHourPriceController.text =
        service.additionalHourPrice?.toStringAsFixed(0) ?? '';
    if (service.features != null) {
      _features.addAll(service.features!);
    }
    if (service.specs != null) {
      _specs.addAll(service.specs!.map((spec) => ServiceSpecData(
            id: spec.id,
            name: spec.name,
            description: spec.description ?? '',
            durationHours: spec.durationHours,
            price: spec.price,
            features: spec.features ?? [],
            isActive: spec.isActive,
          )));
    }
    _isActive = service.isActive;
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.service != null;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(isEdit ? '编辑服务' : '添加服务'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 基本信息卡片
                    _buildSectionCard(
                      title: '基本信息',
                      icon: Icons.info_outline,
                      children: [
                        _buildTextField(
                          controller: _titleController,
                          label: '服务名称',
                          hint: '例如：全程陪诊服务',
                          required: true,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return '请输入服务名称';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),
                        _buildTextField(
                          controller: _categoryController,
                          label: '服务分类',
                          hint: '例如：门诊陪诊、住院陪护',
                        ),
                        SizedBox(height: 16.h),
                        _buildTextField(
                          controller: _descriptionController,
                          label: '服务描述',
                          hint: '详细描述您提供的服务内容',
                          maxLines: 4,
                        ),
                        SizedBox(height: 16.h),
                        _buildTextField(
                          controller: _basePriceController,
                          label: '基础价格',
                          hint: '请输入基础价格(元)',
                          required: true,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return '请输入基础价格';
                            }
                            final price = int.tryParse(value);
                            if (price == null || price <= 0) {
                              return '请输入有效的价格';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),
                        _buildTextField(
                          controller: _additionalHourPriceController,
                          label: '超时加价',
                          hint: '每小时加价(元),可选',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // 服务特色卡片
                    _buildSectionCard(
                      title: '服务特色',
                      icon: Icons.star_outline,
                      children: [
                        // 特色列表
                        if (_features.isNotEmpty) ...[
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: _features.map((feature) {
                              return Chip(
                                label: Text(feature),
                                deleteIcon: const Icon(Icons.close, size: 16),
                                onDeleted: () {
                                  setState(() {
                                    _features.remove(feature);
                                  });
                                },
                                backgroundColor:
                                    AppTheme.primaryColor.withValues(alpha: 0.1),
                                labelStyle: TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontSize: 13.sp,
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 12.h),
                        ],

                        // 添加特色
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _featureController,
                                decoration: InputDecoration(
                                  hintText: '输入服务特色',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 12.h,
                                  ),
                                ),
                                onSubmitted: (_) => _addFeature(),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            ElevatedButton.icon(
                              onPressed: _addFeature,
                              icon: const Icon(Icons.add),
                              label: const Text('添加'),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 12.h,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // 服务规格卡片
                    _buildSectionCard(
                      title: '服务规格',
                      icon: Icons.settings_outlined,
                      children: [
                        // 规格列表
                        if (_specs.isEmpty)
                          Container(
                            padding: EdgeInsets.all(24.w),
                            decoration: BoxDecoration(
                              color: AppTheme.backgroundColor,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.inventory_2_outlined,
                                  size: 48.w,
                                  color: AppTheme.textSecondary.withValues(alpha: 0.5),
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  '暂无服务规格',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  '点击下方按钮添加服务规格',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppTheme.textSecondary.withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          ...List.generate(_specs.length, (index) {
                            final spec = _specs[index];
                            return Container(
                              margin: EdgeInsets.only(bottom: 12.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: AppTheme.primaryColor.withValues(alpha: 0.2),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 规格头部
                                  Container(
                                    padding: EdgeInsets.all(12.w),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryColor.withValues(alpha: 0.05),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12.r),
                                        topRight: Radius.circular(12.r),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            spec.name,
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.textPrimary,
                                            ),
                                          ),
                                        ),
                                        if (!spec.isActive)
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8.w,
                                              vertical: 4.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppTheme.textSecondary.withValues(alpha: 0.2),
                                              borderRadius: BorderRadius.circular(4.r),
                                            ),
                                            child: Text(
                                              '已停用',
                                              style: TextStyle(
                                                fontSize: 11.sp,
                                                color: AppTheme.textSecondary,
                                              ),
                                            ),
                                          ),
                                        SizedBox(width: 8.w),
                                        IconButton(
                                          onPressed: () => _editSpec(index),
                                          icon: const Icon(Icons.edit_outlined),
                                          iconSize: 20.w,
                                          color: AppTheme.primaryColor,
                                        ),
                                        IconButton(
                                          onPressed: () => _deleteSpec(index),
                                          icon: const Icon(Icons.delete_outline),
                                          iconSize: 20.w,
                                          color: AppTheme.errorColor,
                                        ),
                                      ],
                                    ),
                                  ),

                                  // 规格内容
                                  Padding(
                                    padding: EdgeInsets.all(12.w),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (spec.description.isNotEmpty) ...[
                                          Text(
                                            spec.description,
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              color: AppTheme.textSecondary,
                                            ),
                                          ),
                                          SizedBox(height: 8.h),
                                        ],
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.schedule,
                                              size: 16.w,
                                              color: AppTheme.textSecondary,
                                            ),
                                            SizedBox(width: 4.w),
                                            Text(
                                              '时长：${spec.durationHours} 小时',
                                              style: TextStyle(
                                                fontSize: 13.sp,
                                                color: AppTheme.textSecondary,
                                              ),
                                            ),
                                            SizedBox(width: 16.w),
                                            Icon(
                                              Icons.payments,
                                              size: 16.w,
                                              color: AppTheme.primaryColor,
                                            ),
                                            SizedBox(width: 4.w),
                                            Text(
                                              '¥${spec.price.toStringAsFixed(0)}',
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.bold,
                                                color: AppTheme.primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (spec.features.isNotEmpty) ...[
                                          SizedBox(height: 8.h),
                                          Wrap(
                                            spacing: 4.w,
                                            runSpacing: 4.h,
                                            children: spec.features.map((f) {
                                              return Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 8.w,
                                                  vertical: 4.h,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppTheme.successColor.withValues(alpha: 0.1),
                                                  borderRadius: BorderRadius.circular(4.r),
                                                ),
                                                child: Text(
                                                  f,
                                                  style: TextStyle(
                                                    fontSize: 11.sp,
                                                    color: AppTheme.successColor,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),

                        SizedBox(height: 12.h),

                        // 添加规格按钮
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _addSpec,
                            icon: const Icon(Icons.add),
                            label: const Text('添加服务规格'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.primaryColor,
                              side: BorderSide(color: AppTheme.primaryColor),
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // 状态设置卡片
                    _buildSectionCard(
                      title: '状态设置',
                      icon: Icons.toggle_on_outlined,
                      children: [
                        Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: _isActive
                                ? AppTheme.successColor.withValues(alpha: 0.1)
                                : AppTheme.textSecondary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: _isActive
                                  ? AppTheme.successColor.withValues(alpha: 0.3)
                                  : AppTheme.textSecondary.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _isActive ? Icons.visibility : Icons.visibility_off,
                                color: _isActive
                                    ? AppTheme.successColor
                                    : AppTheme.textSecondary,
                                size: 24.w,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _isActive ? '服务已上架' : '服务已下架',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textPrimary,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      _isActive ? '用户可以看到并预订此服务' : '用户无法看到此服务',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: _isActive,
                                onChanged: (value) {
                                  setState(() => _isActive = value);
                                },
                                activeTrackColor: AppTheme.successColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),

                    // 保存按钮
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handleSave,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          isEdit ? '保存修改' : '创建服务',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
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

  /// 构建分区卡片
  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
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
            children: [
              Icon(icon, color: AppTheme.primaryColor, size: 24.w),
              SizedBox(width: 12.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...children,
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
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            if (required) ...[
              SizedBox(width: 4.w),
              Text(
                '*',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppTheme.errorColor,
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 12.h,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  /// 添加服务特色
  void _addFeature() {
    final feature = _featureController.text.trim();
    if (feature.isNotEmpty && !_features.contains(feature)) {
      setState(() {
        _features.add(feature);
        _featureController.clear();
      });
    }
  }

  /// 添加服务规格
  Future<void> _addSpec() async {
    final spec = await showDialog<ServiceSpecData>(
      context: context,
      builder: (context) => const ServiceSpecDialog(),
    );

    if (spec != null) {
      setState(() {
        _specs.add(spec);
      });
    }
  }

  /// 编辑服务规格
  Future<void> _editSpec(int index) async {
    final spec = await showDialog<ServiceSpecData>(
      context: context,
      builder: (context) => ServiceSpecDialog(spec: _specs[index]),
    );

    if (spec != null) {
      setState(() {
        _specs[index] = spec;
      });
    }
  }

  /// 删除服务规格
  Future<void> _deleteSpec(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除规格"${_specs[index].name}"吗？'),
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
      setState(() {
        _specs.removeAt(index);
      });
    }
  }

  /// 保存服务
  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_specs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请至少添加一个服务规格')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // TODO: 调用 API 保存服务和规格
      // 临时方案:创建Service对象并返回
      final now = DateTime.now();
      final serviceId = widget.service?.id ?? now.millisecondsSinceEpoch;

      // 从输入框获取价格
      final basePrice = double.parse(_basePriceController.text.trim());
      final additionalHourPrice = _additionalHourPriceController.text.trim().isEmpty
          ? null
          : double.parse(_additionalHourPriceController.text.trim());

      // 转换规格数据为ServiceSpec对象
      final specs = _specs.map((s) => ServiceSpec(
        id: s.id ?? now.millisecondsSinceEpoch + _specs.indexOf(s),
        serviceId: serviceId,
        name: s.name,
        description: s.description,
        durationHours: s.durationHours,
        price: s.price,
        features: s.features,
        sortOrder: _specs.indexOf(s),
        isActive: s.isActive,
      )).toList();

      final service = Service(
        id: serviceId,
        companionId: 0, // TODO: 从当前登录用户获取
        title: _titleController.text.trim(),
        category: _categoryController.text.trim().isEmpty
            ? null
            : _categoryController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        features: _features.isEmpty ? null : _features,
        basePrice: basePrice,
        additionalHourPrice: additionalHourPrice,
        salesCount: widget.service?.salesCount ?? 0,
        viewCount: widget.service?.viewCount ?? 0,
        isActive: _isActive,
        createdAt: widget.service?.createdAt ?? now,
        specs: specs,
      );

      // 模拟 API 调用
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        // 返回创建的服务对象
        Navigator.of(context).pop(service);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.service != null ? '服务更新成功' : '服务创建成功'),
          ),
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

/// 服务规格数据类
class ServiceSpecData {
  final int? id;
  final String name;
  final String description;
  final int durationHours;
  final double price;
  final List<String> features;
  final bool isActive;

  ServiceSpecData({
    this.id,
    required this.name,
    this.description = '',
    required this.durationHours,
    required this.price,
    this.features = const [],
    this.isActive = true,
  });

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'name': name,
        'description': description,
        'duration_hours': durationHours,
        'price': price,
        'features': features,
        'is_active': isActive,
      };
}

/// 服务规格对话框
class ServiceSpecDialog extends StatefulWidget {
  final ServiceSpecData? spec;

  const ServiceSpecDialog({super.key, this.spec});

  @override
  State<ServiceSpecDialog> createState() => _ServiceSpecDialogState();
}

class _ServiceSpecDialogState extends State<ServiceSpecDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();
  final _priceController = TextEditingController();
  final _featureController = TextEditingController();

  final List<String> _features = [];
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    if (widget.spec != null) {
      _nameController.text = widget.spec!.name;
      _descriptionController.text = widget.spec!.description;
      _durationController.text = widget.spec!.durationHours.toString();
      _priceController.text = widget.spec!.price.toString();
      _features.addAll(widget.spec!.features);
      _isActive = widget.spec!.isActive;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _priceController.dispose();
    _featureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.spec == null ? '添加规格' : '编辑规格'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 规格名称
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: '规格名称 *',
                    hintText: '例如：基础版、标准版、尊享版',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '请输入规格名称';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12.h),

                // 规格描述
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: '规格描述',
                    hintText: '简要说明此规格的特点',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  maxLines: 2,
                ),
                SizedBox(height: 12.h),

                // 服务时长
                TextFormField(
                  controller: _durationController,
                  decoration: InputDecoration(
                    labelText: '服务时长（小时）*',
                    hintText: '例如：4',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    suffix: const Text('小时'),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '请输入服务时长';
                    }
                    final hours = int.tryParse(value);
                    if (hours == null || hours <= 0) {
                      return '请输入有效的时长';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12.h),

                // 价格
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: '价格 *',
                    hintText: '0',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    prefix: const Text('¥ '),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '请输入价格';
                    }
                    final price = double.tryParse(value);
                    if (price == null || price <= 0) {
                      return '请输入有效的价格';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12.h),

                // 规格特色
                Text(
                  '规格特色',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),

                if (_features.isNotEmpty) ...[
                  Wrap(
                    spacing: 6.w,
                    runSpacing: 6.h,
                    children: _features.map((f) {
                      return Chip(
                        label: Text(f, style: TextStyle(fontSize: 12.sp)),
                        deleteIcon: const Icon(Icons.close, size: 14),
                        onDeleted: () {
                          setState(() => _features.remove(f));
                        },
                        backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                        labelStyle: TextStyle(color: AppTheme.primaryColor),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 8.h),
                ],

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _featureController,
                        decoration: InputDecoration(
                          hintText: '输入规格特色',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                        ),
                        onSubmitted: (_) => _addFeature(),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    IconButton(
                      onPressed: _addFeature,
                      icon: const Icon(Icons.add),
                      color: AppTheme.primaryColor,
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // 状态开关
                Row(
                  children: [
                    Text(
                      '启用该规格',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    Switch(
                      value: _isActive,
                      onChanged: (value) {
                        setState(() => _isActive = value);
                      },
                      activeTrackColor: AppTheme.successColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: _handleSave,
          child: Text(widget.spec == null ? '添加' : '保存'),
        ),
      ],
    );
  }

  void _addFeature() {
    final feature = _featureController.text.trim();
    if (feature.isNotEmpty && !_features.contains(feature)) {
      setState(() {
        _features.add(feature);
        _featureController.clear();
      });
    }
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final spec = ServiceSpecData(
      id: widget.spec?.id,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      durationHours: int.parse(_durationController.text),
      price: double.parse(_priceController.text),
      features: _features,
      isActive: _isActive,
    );

    Navigator.of(context).pop(spec);
  }
}
