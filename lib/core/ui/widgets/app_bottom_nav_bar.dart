import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../gen/assets.gen.dart';

final class AppBottomNavBarVisibilityController extends ChangeNotifier {
  bool _isVisible = true;

  bool get isVisible => _isVisible;

  void show() {
    if (_isVisible) return;
    _isVisible = true;
    notifyListeners();
  }

  void hide() {
    if (!_isVisible) return;
    _isVisible = false;
    notifyListeners();
  }

  void reset() => show();
}

final class AppBottomNavBarVisibilityScope
    extends InheritedNotifier<AppBottomNavBarVisibilityController> {
  const AppBottomNavBarVisibilityScope({
    required AppBottomNavBarVisibilityController controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  static AppBottomNavBarVisibilityController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AppBottomNavBarVisibilityScope>()
        ?.notifier;
  }
}

final class AppBottomNavItem {
  const AppBottomNavItem({required this.label, required this.icon});

  final String label;
  final SvgGenImage icon;
}

final class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    required this.items,
    required this.currentIndex,
    required this.onItemSelected,
    this.visible = true,
    super.key,
  });

  final List<AppBottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onItemSelected;
  final bool visible;

  static const double height = 69;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 280),
      reverseDuration: const Duration(milliseconds: 240),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final slide = Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(animation);
        return ClipRect(
          child: SizeTransition(
            sizeFactor: animation,
            axisAlignment: -1,
            child: SlideTransition(position: slide, child: child),
          ),
        );
      },
      child: visible
          ? _AppBottomNavBarContent(
              key: const ValueKey('visible'),
              items: items,
              currentIndex: currentIndex,
              onItemSelected: onItemSelected,
            )
          : const SizedBox(key: ValueKey('hidden')),
    );
  }
}

final class _AppBottomNavBarContent extends StatelessWidget {
  const _AppBottomNavBarContent({
    required this.items,
    required this.currentIndex,
    required this.onItemSelected,
    super.key,
  });

  final List<AppBottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surfaceLight,
        border: Border(top: BorderSide(color: AppColors.mutedSurface)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: AppBottomNavBar.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Row(
              children: [
                for (var index = 0; index < items.length; index++)
                  Expanded(
                    child: _AppBottomNavTile(
                      item: items[index],
                      selected: currentIndex == index,
                      onTap: () => onItemSelected(index),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final class _AppBottomNavTile extends StatelessWidget {
  const _AppBottomNavTile({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final AppBottomNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.placeholder;

    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              item.icon.svg(
                width: 22,
                height: 22,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                excludeFromSemantics: true,
              ),
              const SizedBox(height: 5),
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 10,
                  height: 14 / 10,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
