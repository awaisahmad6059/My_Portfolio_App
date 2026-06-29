import 'package:flutter/material.dart';
import 'package:aak/core/constants/app_strings.dart';

class PinDialog extends StatefulWidget {
  const PinDialog({super.key});

  @override
  State<PinDialog> createState() => _PinDialogState();
}

class _PinDialogState extends State<PinDialog> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppStrings.adminPinTitle),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        obscureText: true,
        maxLength: 4,
        decoration: InputDecoration(
          hintText: AppStrings.adminPinHint,
          errorText: _error,
          counterText: '',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text(AppStrings.cancel),
        ),
        TextButton(
          onPressed: () {
            if (_controller.text == '1290') {
              Navigator.of(context).pop(true);
            } else {
              setState(() => _error = AppStrings.adminPinInvalid);
            }
          },
          child: const Text(AppStrings.adminPinSubmit),
        ),
      ],
    );
  }
}
