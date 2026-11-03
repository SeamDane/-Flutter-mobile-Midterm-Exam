import '../../core/constants/api_constants.dart';
import '../../core/models/page_result.dart';
import '../../core/network/api_client.dart';
import '../models/employee.dart';

abstract class EmployeeRepository {
  Future<PageResult<Employee>> getEmployees({int limit = 20, int skip = 0});
  Future<Employee> addEmployee(Employee employee);
  Future<Employee> updateEmployee(Employee employee);
  Future<void> deleteEmployee(Employee employee);
}

class EmployeeRepositoryImpl implements EmployeeRepository {
  EmployeeRepositoryImpl(this._api);
  final ApiClient _api;

  @override
  Future<PageResult<Employee>> getEmployees({int limit = 20, int skip = 0}) async {
    final data = await _api.get(ApiConstants.employees, query: {
      'limit': limit,
      'skip': skip,
      'select': 'firstName,lastName,email,phone,age,company',
    }) as Map<String, dynamic>;

    final items = (data['users'] as List)
        .map((e) => Employee.fromJson(e as Map<String, dynamic>))
        .toList();
    return PageResult(items: items, total: (data['total'] as num?)?.toInt() ?? items.length);
  }

  @override
  Future<Employee> addEmployee(Employee employee) async {
    final res = await _api.post(ApiConstants.employeeAdd, data: employee.toJson());
    final id = (res as Map<String, dynamic>)['id'] as int?;
    return employee.copyWith(id: id, isLocal: ApiConstants.simulatedBackend);
  }

  @override
  Future<Employee> updateEmployee(Employee employee) async {
    // Locally-created records don't exist on the simulated backend.
    if (!employee.isLocal) {
      await _api.put('${ApiConstants.employees}/${employee.id}', data: employee.toJson());
    }
    return employee;
  }

  @override
  Future<void> deleteEmployee(Employee employee) async {
    if (!employee.isLocal) {
      await _api.delete('${ApiConstants.employees}/${employee.id}');
    }
  }
}
