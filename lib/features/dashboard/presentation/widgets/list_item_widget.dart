import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test_task_flavours/shared/domain/models/product/product_model.dart';
import 'package:test_task_flavours/shared/theme/app_colors.dart';
import 'package:test_task_flavours/shared/theme/test_styles.dart';

class ListItemWidget extends StatelessWidget {
  const ListItemWidget(
    this.product, {
    this.isChecked = false,
    this.onTapCheck,
    this.showCheckBoxwithOverlay = false,
    super.key,
  });

  final Product product;
  final bool isChecked;
  final bool showCheckBoxwithOverlay;

  final void Function(bool?)? onTapCheck;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: ShapeDecoration(
        color: const Color(0xFFEDEEF0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: NetworkImage(product.thumbnail),
                    fit: BoxFit.fill,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              Positioned(
                right: 0,
                child: Visibility(
                  visible: showCheckBoxwithOverlay,
                  child: Checkbox(
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.all(
                        isChecked ? AppColors.primary : AppColors.white),
                    value: isChecked,
                    activeColor: AppColors.primary,
                    shape: const CircleBorder(),
                    onChanged: onTapCheck,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SAR ${product.price.toDouble()}',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${product.rating.toDouble()} ',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.rattingColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SvgPicture.asset(
                          "assets/icons/Star.svg",
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  product.title,
                  style: AppTextStyles.bodyLg,
                ),
                Text(
                  product.description,
                  style: AppTextStyles.body,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
