import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:saise_de_temps/models/form_element_model.dart';
import 'package:saise_de_temps/models/time_options_model.dart';
import 'package:saise_de_temps/services/database/db.dart';

class TimeSelectionFormField extends FormField<String> {
  final FormElementModel? question;
  final BuildContext? context;

  TimeSelectionFormField(
      {Key? key,
      this.question,
      this.context,
      FormFieldSetter<String>? onSaved,
      FormFieldValidator<String>? validator,
      String? initialValue = "",
      bool? showError = false,
      AutovalidateMode autovalidate = AutovalidateMode.disabled})
      : super(
            key: key,
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidateMode: autovalidate,
            builder: (FormFieldState<String> state) {
              TimeOptionModel? timeOptionModel = question!.getTimeOptionModel();

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      question.text!,
                      style: TextStyle(
                          fontSize: timeOptionModel.size!),
                    ),
                    InkWell(
                      onTap: () {
                        DatePicker.showTimePicker(context!,
                            showTitleActions: true,
                            onChanged: (date) {}, onConfirm: (date) {
                          showError = false;
                          state.didChange(date.hour.toString() +
                              "h" +
                              date.minute.toString() +
                              "m" +
                              date.second.toString() +
                              "s");
                        }, currentTime: DateTime.now());
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(12, 0, 20, 0),
                          errorText:
                              showError == true ? "Time not selected" : null,
                          errorStyle: TextStyle(
                              color: Colors.redAccent,
                              fontSize: timeOptionModel.size!),
                        ),
                        child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            height: 100,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Colors.grey[200]),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 100,
                                  child: Center(
                                    child: Text(
                                      state.value!,
                                      style: TextStyle(
                                          fontSize: timeOptionModel.size!),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 0,
                                  width: 0,
                                  child: TextFormField(
                                    validator: (text) {
                                      if (state.value!.isEmpty) {
                                        showError = true;
                                        return "Time Not selected";
                                      }
                                    },
                                    onSaved: (text){
                                      DB.db.saveField(question.id, state.value!);
                                    },
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ],
                ),
              );
            });
}
