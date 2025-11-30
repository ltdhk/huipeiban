import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/patient.dart';
import '../../data/repositories/patient_repository.dart';

part 'patient_controller.g.dart';

/// 就诊人控制器
@riverpod
class PatientController extends _$PatientController {
  late final PatientRepository _repository;

  @override
  FutureOr<List<Patient>> build() async {
    _repository = PatientRepository();
    return await _repository.getPatients();
  }

  /// 加载就诊人列表
  Future<void> loadPatients() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _repository.getPatients();
    });
  }

  /// 创建就诊人
  Future<void> create(Map<String, dynamic> data) async {
    final newPatient = await _repository.createPatient(data);
    final current = state.value ?? [];
    state = AsyncValue.data([...current, newPatient]);
  }

  /// 更新就诊人
  Future<void> updatePatient(int id, Map<String, dynamic> data) async {
    final updated = await _repository.updatePatient(id, data);
    final current = state.value ?? [];
    state = AsyncValue.data(
      current.map((p) => p.id == id ? updated : p).toList(),
    );
  }

  /// 删除就诊人
  Future<void> delete(int id) async {
    await _repository.deletePatient(id);
    final current = state.value ?? [];
    state = AsyncValue.data(current.where((p) => p.id != id).toList());
  }

  /// 设置默认就诊人
  Future<void> setDefault(int id) async {
    final updated = await _repository.setDefaultPatient(id);
    final current = state.value ?? [];
    // 更新所有就诊人的 isDefault 状态
    state = AsyncValue.data(
      current.map((p) {
        if (p.id == id) {
          return updated;
        }
        // 取消其他就诊人的默认状态
        if (p.isDefault) {
          return p.copyWith(isDefault: false);
        }
        return p;
      }).toList(),
    );
  }

  /// 获取默认就诊人
  Patient? getDefaultPatient() {
    final current = state.value;
    if (current == null || current.isEmpty) return null;
    return current.firstWhere(
      (p) => p.isDefault,
      orElse: () => current.first,
    );
  }
}
