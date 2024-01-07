import 'package:test_task_flavours/core/typedef.dart';

abstract class DashboardRepository {
  ResultFuture fetchProducts({required int skip});
  ResultFuture searchProducts({required int skip, required String query});
}
