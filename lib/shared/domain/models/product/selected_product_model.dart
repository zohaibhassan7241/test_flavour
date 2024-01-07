import 'package:test_task_flavours/shared/domain/models/product/product_model.dart';

class SelectedProductModel {
  final Product? product;
  final bool isSelected;

  SelectedProductModel({this.product, required this.isSelected});
}
