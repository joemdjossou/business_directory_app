import 'package:flutter/material.dart';

import '../../utils/constants.dart';

/// Generic base card widget that can render any type of item
abstract class BaseCard<T> extends StatelessWidget {
  final T item;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final BorderRadius? borderRadius;

  const BaseCard({
    super.key,
    required this.item,
    this.onTap,
    this.padding,
    this.margin,
    this.elevation,
    this.borderRadius,
  });

  /// Abstract method to build the content of the card
  Widget buildContent(BuildContext context, T item);

  /// Abstract method to get the title for accessibility
  String getTitle(T item);

  /// Abstract method to get the subtitle for accessibility
  String? getSubtitle(T item);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation ?? AppConstants.cardElevation,
      margin:
          margin ??
          const EdgeInsets.symmetric(
            horizontal: AppConstants.listPadding,
            vertical: 4.0,
          ),
      shape: RoundedRectangleBorder(
        borderRadius:
            borderRadius ??
            BorderRadius.circular(AppConstants.cardBorderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius:
            borderRadius ??
            BorderRadius.circular(AppConstants.cardBorderRadius),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16.0),
          child: Semantics(
            label: getTitle(item),
            hint: getSubtitle(item),
            button: onTap != null,
            child: buildContent(context, item),
          ),
        ),
      ),
    );
  }
}
