import 'package:flutter/material.dart';
import 'package:wiredash/src/_wiredash_internal.dart';
import 'package:wiredash/src/_wiredash_ui.dart';
import 'package:wiredash/src/nps/nps_model.dart';
import 'package:wiredash/src/nps/nps_model_provider.dart';

class NpsStep2Message extends StatefulWidget {
  const NpsStep2Message({
    Key? key,
  }) : super(key: key);

  @override
  State<NpsStep2Message> createState() => _NpsStep2MessageState();
}

class _NpsStep2MessageState extends State<NpsStep2Message>
    with TickerProviderStateMixin {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: NpsModelProvider.of(context, listen: false).message,
    )..addListener(() {
        final text = _controller.text;
        if (context.npsModel.message != text) {
          context.npsModel.message = text;
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StepPageScaffold(
      indicator: const StepIndicator(
        currentStep: 2,
        total: 2,
        completed: false,
      ),
      // title: const Text('What is the most important reason for your score?'),
      title: Text(context.l10n.npsStep2MessageTitle),
      description: Text(
        context.l10n
            .npsStep2MessageDescription(context.npsModel.score!.intValue),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // reduce size when it doesn't fit
          Flexible(
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.multiline,
              minLines: context.theme.windowSize.height > 400 ? 3 : 2,
              maxLines: 10,
              maxLength: 2048,
              buildCounter: _getCounterText,
              style: context.text.input.onBackground,
              cursorColor: context.theme.primaryColor,
              decoration: InputDecoration(
                filled: true,
                fillColor: context.theme.primaryBackgroundColor,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: context.theme.secondaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: context.theme.secondaryColor),
                ),
                errorBorder: InputBorder.none,
                hoverColor: context.theme.brightness == Brightness.light
                    ? context.theme.primaryBackgroundColor.darken(0.015)
                    : context.theme.primaryBackgroundColor.lighten(0.015),
                hintText: context.l10n.npsStep2MessageHint,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                hintStyle: context.text.input.onSurface.copyWith(
                  color: context.text.input.onSurface.color?.withOpacity(0.6),
                ),
                errorStyle: context.text.inputError.textStyle.copyWith(
                  color: context.theme.errorColor,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TronButton(
                color: context.theme.secondaryColor,
                label: context.l10n.npsNextButton,
                onTap: () {
                  context
                      .findAncestorStateOfType<LarryPageViewState>()!
                      .moveToPreviousPage();
                },
              ),
              TronButton(
                label: context.l10n.npsDoneButton,
                trailingIcon: Wirecons.check,
                onTap: () {
                  context.npsModel.submit();
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}

Widget? _getCounterText(
  /// The build context for the TextField.
  BuildContext context, {

  /// The length of the string currently in the input.
  required int currentLength,

  /// The maximum string length that can be entered into the TextField.
  required int? maxLength,

  /// Whether or not the TextField is currently focused.  Mainly provided for
  /// the [liveRegion] parameter in the [Semantics] widget for accessibility.
  required bool isFocused,
}) {
  final max = maxLength ?? 2048;
  final remaining = max - currentLength;

  Color getCounterColor() {
    if (remaining >= 150) {
      return Colors.green.shade400.withOpacity(0.8);
    } else if (remaining >= 50) {
      return Colors.orange.withOpacity(0.8);
    }
    return Theme.of(context).errorColor;
  }

  return Text(
    remaining > 150 ? '' : remaining.toString(),
    style: context.text.inputError.textStyle.copyWith(color: getCounterColor()),
  );
}
