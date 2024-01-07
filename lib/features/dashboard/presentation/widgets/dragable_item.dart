import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_task_flavours/features/dashboard/presentation/widgets/delete_alert_dialog_widget.dart';
import 'package:test_task_flavours/shared/theme/app_colors.dart';

class DraggableItemTile extends StatefulWidget {
  const DraggableItemTile({
    Key? key,
    required this.child,
    this.onDeleteTap,
  }) : super(key: key);
  final Widget child;
  final void Function()? onDeleteTap;

  @override
  State<DraggableItemTile> createState() => _DraggableItemTileState();
}

class _DraggableItemTileState extends State<DraggableItemTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Animation<Offset> animation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.2, 0.0),
    ).animate(CurveTween(curve: Curves.decelerate).animate(_controller));

    return GestureDetector(
      onHorizontalDragUpdate: (DragUpdateDetails data) {
        setState(() {
          _controller.value -= data.primaryDelta! / (context.size!.width * 0.2);
        });
      },
      onHorizontalDragEnd: (DragEndDetails data) {
        if (data.primaryVelocity! > 1500) {
          _controller.animateTo(.0);
        } else if (_controller.value >= .5 || data.primaryVelocity! < -1500) {
          _controller.animateTo(1.0);
        } else {
          _controller.animateTo(.0);
        }
      },
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraint) {
          return Stack(
            children: <Widget>[
              AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, Widget? child) {
                  return Positioned(
                    right: 10,
                    top: .0,
                    bottom: .0,
                    width: constraint.maxWidth * animation.value.dx * -1,
                    child: GestureDetector(
                      onTap: widget.onDeleteTap,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: AppColors.deleteColorBg,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              DialogUtil.showDeleteDialog(
                                context: context,
                                confirmButtonText: 'Remove',
                                cancelButtonText: 'Cancel',
                                bodyText: 'Remove product?',
                                bodySubText:
                                    'This action is irreversible and will permanently delete the product.',
                                onConfirm: () {
                                  Navigator.pop(context);
                                },
                              );
                            },
                            child: SvgPicture.asset(
                              "assets/icons/Delete.svg",
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SlideTransition(
                position: animation,
                child: widget.child,
              ),
            ],
          );
        },
      ),
    );
  }
}
