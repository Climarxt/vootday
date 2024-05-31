import 'package:bootdv2/config/configs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

class CreatePostField extends StatelessWidget {
  final BuildContext context;
  final String label;
  final String value;
  final Function(BuildContext) navigateFunction;

  const CreatePostField(this.context, this.label, this.value, this.navigateFunction, {super.key});

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: () {
        navigateFunction(context);
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                label,
                style: AppTextStyles.titleLargeBlackBold(context),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          value.isEmpty ? 'Add ${label.toLowerCase()}' : value,
                          style: value.isEmpty
                              ? AppTextStyles.bodyStyleGrey(context)
                              : AppTextStyles.bodyStyle(context),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: black, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
