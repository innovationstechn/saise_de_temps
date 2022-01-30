import 'package:flutter/material.dart';
import 'package:saise_de_temps/models/checkbox_options_model.dart';
import 'package:saise_de_temps/models/form_element_model.dart';

class CheckboxIconFormField extends FormField<bool> {
  final FormElementModel question;
  final CheckBoxOptionModel checkBoxOptionModel;

  CheckboxIconFormField({
    required this.question,
    required this.checkBoxOptionModel,
    required FormFieldSetter<bool?> onSaved,
    required FormFieldValidator<bool?> validator,
    Key? key,
    BuildContext? context,
    bool? initialValue,
    ValueChanged<bool>? onChanged,
    AutovalidateMode? autoValidateMode = AutovalidateMode.disabled,
    bool enabled = true,
    IconData trueIcon = Icons.check,
    IconData falseIcon = Icons.check_box_outline_blank,
    Color? trueIconColor,
    Color? falseIconColor,
    Color? disabledColor,
    EdgeInsets padding = EdgeInsets.zero,
    double? iconSize,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidateMode: autoValidateMode,
          builder: (FormFieldState<bool> state) {
            trueIconColor ??= (context == null
                ? null
                : Theme.of(context).colorScheme.secondary);
            return Padding(
              padding: padding,
              child: Row(
                children: [
                  Text(
                    question.text!,
                    style: TextStyle(
                        fontSize: checkBoxOptionModel.size!),
                  ),
                  const Spacer(),
                  state.value!
                      ? _createTappableIcon(
                          state,
                          enabled,
                          trueIcon,
                          onChanged,
                          trueIconColor,
                          disabledColor,
                          iconSize,
                        )
                      : _createTappableIcon(
                          state,
                          enabled,
                          falseIcon,
                          onChanged,
                          falseIconColor,
                          disabledColor,
                          iconSize,
                        )
                ],
              ),
            );
          },
        );

  static Widget _createTappableIcon(
    FormFieldState<bool> state,
    bool enabled,
    IconData icon,
    ValueChanged<bool>? onChanged,
    Color? iconColor,
    Color? disabledColor,
    double? iconSize,
  ) {
    return IconButton(
      onPressed: enabled
          ? () {
              state.didChange(!state.value!);
              if (onChanged != null) onChanged(state.value!);
            }
          : null,
      icon: Icon(
        icon,
        color: enabled ? iconColor : disabledColor,
        size: iconSize,
      ),
    );
  }
}
