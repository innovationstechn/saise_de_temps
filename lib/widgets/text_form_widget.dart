import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saise_de_temps/models/form_element_model.dart';
import 'package:saise_de_temps/models/text_options_model.dart';
import 'package:saise_de_temps/services/database/db.dart';

class TextFormWidget extends FormField<String> {
  final FormElementModel? question;
  final BuildContext? context;
  final TextEditingController? textEditingController ;

  TextFormWidget(
      {Key? key,
      this.question,
      this.context,
      this.textEditingController,
      FormFieldSetter<String>? onSaved,
      FormFieldValidator<String>? validator,
      String initialValue = "",
      AutovalidateMode autoValidate = AutovalidateMode.disabled})
      : super(
            key: key,
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidateMode: autoValidate,
            builder: (FormFieldState<String> state) {
              TextOptionModel? textOptionModel = question!.getTextOptionModel();

              textEditingController!.addListener(() {
                if (textEditingController.text.length >
                    textOptionModel!.minLength!) {
                  state.didChange(textEditingController.text);
                } else {
                  state.didChange("");
                }
              });
              return Container(
                margin: const EdgeInsets.only(top:10),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question.text!,
                        style: TextStyle(
                            fontSize: textOptionModel!.size!),
                      ),
                      TextFormField(
                        maxLength: textOptionModel.maxLength,
                        controller: textEditingController,
                        validator: (text) {
                          if (text!.isEmpty) {
                            if(textOptionModel.required!){
                              return "Field should not be empty";
                            }
                            return null;
                          } else {
                            if(text.length<textOptionModel.minLength!) {
                             return "Text length should be greater then"+textOptionModel.minLength!.toString();
                            }
                          }
                        },
                        onSaved: (String? value){
                          DB.db.saveField(question.id, value);
                        },
                        decoration: InputDecoration(
                          labelText: textOptionModel.value,
                        ),
                        style:
                            TextStyle(fontSize: textOptionModel.size!),
                        keyboardType: question.type == "text"
                            ? TextInputType.text
                            : TextInputType.number,
                      ),
                    ],
                  ),
                ),
              );
            });
}
