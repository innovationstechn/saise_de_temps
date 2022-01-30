import 'package:flutter/material.dart';
import 'package:saise_de_temps/models/form_element_model.dart';
import 'package:saise_de_temps/models/text_options_model.dart';

class TextFormWidget extends FormField<String> {
  final FormElementModel? question;
  final BuildContext? context;
  final TextOptionModel? textOptionModel;
  final TextEditingController? textEditingController;

  TextFormWidget(
      {Key? key,
      this.question,
      this.context,
      this.textOptionModel,
      this.textEditingController,
      required FormFieldSetter<String> onSaved,
      required FormFieldValidator<String> validator,
      String initialValue = "",
      bool? showError = false,
      AutovalidateMode autovalidate = AutovalidateMode.disabled})
      : super(
            key: key,
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidateMode: autovalidate,
            builder: (FormFieldState<String> state) {
              textEditingController!.addListener(() {
                if (textEditingController.text.length >
                    textOptionModel!.minLength!) {
                  if (showError!) {
                    showError = false;
                  }
                  state.didChange(textEditingController.text);
                } else {
                  state.didChange("");
                }
              });
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      question!.text!,
                      style: TextStyle(
                          fontSize: textOptionModel!.size!),
                    ),
                    TextFormField(
                      maxLength: textOptionModel.maxLength,
                      controller: textEditingController,
                      validator: (text) {
                        if (text!.isEmpty) {
                          showError = true;
                        } else {
                          if(text.length<textOptionModel.minLength!) {
                           showError = true;
                          } else {
                            showError = false;
                          }
                        }
                      },
                      decoration: InputDecoration(
                        labelText: textOptionModel.value,
                        errorText: showError == true
                            ? textEditingController.text.isNotEmpty
                                ? 'Length should be greater than ' +
                                    textOptionModel.minLength.toString()
                                : " Field should not be empty"
                            : null,
                      ),
                      style:
                          TextStyle(fontSize: textOptionModel.size!),
                      keyboardType: question.type == "text"
                          ? TextInputType.text
                          : TextInputType.number,
                    ),
                  ],
                ),
              );
            });
}
