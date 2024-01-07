import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:test_task_flavours/features/dashboard/presentation/providers/dashboard_state_provider.dart';
import 'package:test_task_flavours/features/dashboard/presentation/providers/state/dashboard_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_task_flavours/features/dashboard/presentation/widgets/delete_alert_dialog_widget.dart';
import 'package:test_task_flavours/features/dashboard/presentation/widgets/dragable_item.dart';
import 'package:test_task_flavours/features/dashboard/presentation/widgets/list_item_widget.dart';
import 'package:test_task_flavours/shared/domain/models/product/selected_product_model.dart';
import 'package:test_task_flavours/shared/theme/app_colors.dart';
import 'package:test_task_flavours/shared/theme/test_styles.dart';
import 'package:test_task_flavours/shared/widgets/gap.dart';

@RoutePage()
class DashboardScreen extends ConsumerStatefulWidget {
  static const String routeName = 'DashboardScreen';

  const DashboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final scrollController = ScrollController();
  bool isEditActive = false;
  Timer? _debounce;
  int count = 0;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollControllerListener);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void scrollControllerListener() {
    if (scrollController.position.maxScrollExtent == scrollController.offset) {
      final notifier = ref.read(dashboardNotifierProvider.notifier);

      notifier.fetchProducts();
    }
  }

  void refreshScrollControllerListener() {
    scrollController.removeListener(scrollControllerListener);
    scrollController.addListener(scrollControllerListener);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardNotifierProvider);

    ref.listen(
      dashboardNotifierProvider.select((value) => value),
      ((DashboardState? previous, DashboardState next) {
        //show Snackbar on failure
        if (next.state == DashboardConcreteState.fetchedAllProducts) {
          if (next.message.isNotEmpty) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(next.message.toString())));
          }
        }
      }),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: AppTextStyles.bodyLg,
        ),
        centerTitle: true,
        leadingWidth: 60,
        leading: Center(
          child: InkWell(
            onTap: () {
              if (isEditActive) {
                isEditActive = !isEditActive;
              } else {
                isEditActive = true;
              }
              setState(() {});
            },
            child: Text(
              isEditActive ? 'Cancel' : 'Edit',
              style: AppTextStyles.bodyLg.copyWith(
                fontWeight: FontWeight.w400,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        actions: [
          Visibility(
            visible: isEditActive,
            child: InkWell(
              onTap: () {
                if (state.hasData) {
                  count = state.selectedProductModel
                      .where((element) => element.isSelected == true)
                      .length;
                  if (count != 0) {
                    DialogUtil.showDeleteDialog(
                      context: context,
                      confirmButtonText: 'Remove',
                      cancelButtonText: 'Cancel',
                      bodyText: 'Remove $count products?',
                      bodySubText:
                          'This action is irreversible and will permanently delete the product.',
                      onConfirm: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$count products removed.',
                                style: const TextStyle(
                                    color: AppColors.white, fontSize: 14.5)),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                              },
                            ),
                            duration: const Duration(seconds: 5),
                          ),
                        );
                        Navigator.pop(context);
                      },
                    );
                  }
                }
              },
              child: Text('Delete',
                  style: AppTextStyles.bodyLg.copyWith(
                    color: AppColors.primary,
                  )),
            ),
          ),
          const Gap(20),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: state.state == DashboardConcreteState.loading
            ? const Center(child: CircularProgressIndicator())
            : state.hasData
                ? Column(
                    children: [
                      Expanded(
                        child: Scrollbar(
                          controller: scrollController,
                          child: ListView.separated(
                            separatorBuilder: (_, __) => const SizedBox(
                              height: 8.0,
                            ),
                            controller: scrollController,
                            itemCount: state.productList.length,
                            itemBuilder: (context, index) {
                              final product = state.productList[index];

                              // return ListItemWidget(product);
                              return DraggableItemTile(
                                child: ListItemWidget(
                                  product,
                                  onTapCheck: (value) {
                                    if (value == true) {
                                      state.selectedProductModel[index] =
                                          SelectedProductModel(
                                              isSelected: true,
                                              product: product);
                                      setState(() {});
                                    } else {
                                      state.selectedProductModel[index] =
                                          SelectedProductModel(
                                              isSelected: false,
                                              product: product);
                                      setState(() {});
                                    }
                                  },
                                  isChecked: state
                                      .selectedProductModel[index].isSelected,
                                  showCheckBoxwithOverlay: isEditActive,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      if (state.state == DashboardConcreteState.fetchingMore)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 16.0),
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22.0),
                      child: Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
