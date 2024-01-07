// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:test_task_flavours/shared/domain/models/product/product_model.dart';
import 'package:test_task_flavours/shared/domain/models/product/selected_product_model.dart';

enum DashboardConcreteState {
  initial,
  loading,
  loaded,
  failure,
  fetchingMore,
  fetchedAllProducts
}

class DashboardState extends Equatable {
  final List<Product> productList;
  final List<SelectedProductModel> selectedProductModel;

  final int total;
  final int page;
  final bool hasData;
  final DashboardConcreteState state;
  final String message;
  final bool isLoading;
  const DashboardState({
    this.productList = const [],
    this.selectedProductModel = const [],
    this.isLoading = false,
    this.hasData = false,
    this.state = DashboardConcreteState.initial,
    this.message = '',
    this.page = 0,
    this.total = 0,
  });

  const DashboardState.initial({
    this.productList = const [],
    this.selectedProductModel = const [],
    this.total = 0,
    this.page = 0,
    this.isLoading = false,
    this.hasData = false,
    this.state = DashboardConcreteState.initial,
    this.message = '',
  });

  DashboardState copyWith({
    List<Product>? productList,
    List<SelectedProductModel>? selectedProductModel,
    int? total,
    int? page,
    bool? hasData,
    DashboardConcreteState? state,
    String? message,
    bool? isLoading,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      productList: productList ?? this.productList,
      selectedProductModel: selectedProductModel ?? this.selectedProductModel,
      total: total ?? this.total,
      page: page ?? this.page,
      hasData: hasData ?? this.hasData,
      state: state ?? this.state,
      message: message ?? this.message,
    );
  }

  @override
  String toString() {
    return 'DashboardState(isLoading:$isLoading, productLength: ${productList.length},total:$total page: $page, hasData: $hasData, state: $state, message: $message)';
  }

  @override
  List<Object?> get props =>
      [productList, selectedProductModel, page, hasData, state, message];
}
