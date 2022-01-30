import 'package:flutter/material.dart';
import 'package:saise_de_temps/models/dropdown_options_model.dart';
import 'package:saise_de_temps/models/form_element_model.dart';

class DropDownFormField extends FormField<String> {
  final FormElementModel? question;
  final BuildContext? context;
  final DropDownOptionModel? dropDownOptionModel;

  DropDownFormField(
      {Key? key,
      this.question,
      this.context,
      this.dropDownOptionModel,
      bool? showError = false,
      required FormFieldSetter<String> onSaved,
      required FormFieldValidator<String> validator,
      AutovalidateMode autovalidate = AutovalidateMode.disabled})
      : super(
            key: key,
            onSaved: onSaved,
            validator: validator,
            autovalidateMode: autovalidate,
            builder: (FormFieldState<String> state) {
              return Center(
                child: Container(
                  margin: const EdgeInsets.only(left: 15, top: 10, right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(question!.text!,style: TextStyle(fontSize: dropDownOptionModel!.size!),),
                      const SizedBox(
                        height: 15,
                      ),
                      InputDecorator(
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(12, 0, 20, 0),
                          errorText: showError==true?"Item not selected":null,
                          errorStyle: TextStyle(
                              color: Colors.redAccent, fontSize: dropDownOptionModel.size!),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            style: TextStyle(
                              fontSize: dropDownOptionModel.size!,
                              color: Colors.grey,
                              fontFamily: "verdana_regular",
                            ),
                            hint: Text(
                              "Please select an item",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: dropDownOptionModel.size!,
                                fontFamily: "verdana_regular",
                              ),
                            ),
                            items: dropDownOptionModel.list!
                                .map<DropdownMenuItem<String>>(
                              (String? value) {
                                return DropdownMenuItem(
                                  value: value!,
                                  child: Row(
                                    children: [
                                      Text(value,style: TextStyle(fontSize: dropDownOptionModel.size!),),
                                    ],
                                  ),
                                );
                              },
                            ).toList(),
                            isExpanded: true,
                            isDense: true,
                            onChanged: (String? newSelectedBank) {
                              showError = false;
                              state.didChange(newSelectedBank.toString());
                            },
                            value: state.value,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 0,
                        width: 0,
                        child: TextFormField(
                          validator: (text) {
                            if (state.value==null) {
                              showError = true;
                            }
                          },
                        ),
                      ),

                    ],
                  ),
                ),
              );
            });
}
