import 'package:test_task_flavours/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:test_task_flavours/features/dashboard/presentation/providers/state/dashboard_state.dart';
import 'package:test_task_flavours/shared/domain/models/either.dart';
import 'package:test_task_flavours/shared/domain/models/paginated_response.dart';
import 'package:test_task_flavours/shared/domain/models/product/product_model.dart';
import 'package:test_task_flavours/shared/domain/models/product/selected_product_model.dart';
import 'package:test_task_flavours/shared/exceptions/http_exception.dart';
import 'package:test_task_flavours/shared/globals.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardNotifier extends StateNotifier<DashboardState> {
  final DashboardRepository dashboardRepository;

  DashboardNotifier(
    this.dashboardRepository,
  ) : super(const DashboardState.initial());

  bool get isFetching =>
      state.state != DashboardConcreteState.loading &&
      state.state != DashboardConcreteState.fetchingMore;

  Future<void> fetchProducts() async {
    if (isFetching &&
        state.state != DashboardConcreteState.fetchedAllProducts) {
      state = state.copyWith(
        state: state.page > 0
            ? DashboardConcreteState.fetchingMore
            : DashboardConcreteState.loading,
        isLoading: true,
      );

      final response = await dashboardRepository.fetchProducts(
          skip: state.page * PRODUCTS_PER_PAGE);

      updateStateFromResponse(response);
    } else {
      state = state.copyWith(
        state: DashboardConcreteState.fetchedAllProducts,
        message: 'No more products available',
        isLoading: false,
      );
    }
  }

  void updateStateFromResponse(
      Either<AppException, PaginatedResponse<dynamic>> response) {
    response.fold((failure) {
      state = state.copyWith(
        state: DashboardConcreteState.failure,
        message: failure.message,
        isLoading: false,
      );
    }, (data) {
      final productList = data.data.map((e) => Product.fromJson(e)).toList();
      final selectedProductModeel = List<SelectedProductModel>.filled(
          productList.length, SelectedProductModel(isSelected: false),
          growable: true);

      final totalProducts = [...state.productList, ...productList];

      final totalProductsModel = [
        ...state.selectedProductModel,
        ...selectedProductModeel
      ];

      state = state.copyWith(
        productList: totalProducts,
        selectedProductModel: totalProductsModel,
        state: totalProducts.length == data.total
            ? DashboardConcreteState.fetchedAllProducts
            : DashboardConcreteState.loaded,
        hasData: true,
        message: totalProducts.isEmpty ? 'No products found' : '',
        page: totalProducts.length ~/ PRODUCTS_PER_PAGE,
        total: data.total,
        isLoading: false,
      );
    });
  }

  void resetState() {
    state = const DashboardState.initial();
  }
}
