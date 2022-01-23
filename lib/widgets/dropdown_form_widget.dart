import 'package:flutter/material.dart';
import 'package:saise_de_temps/models/form_element_model.dart';

class DropDownFormWidget extends StatefulWidget {
  final FormElementModel question;
  final String hint;

  const DropDownFormWidget(
      {Key? key, required this.question, this.hint = "Please select an item"})
      : super(key: key);

  @override
  State<DropDownFormWidget> createState() => _DropDownFormWidgetState();
}

class _DropDownFormWidgetState extends State<DropDownFormWidget> {
  late String _bankChoose;

  @override
  void initState() {
    super.initState();

    _bankChoose = widget.question.values!.first!;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(left: 15, top: 10, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.question.text!),
            SizedBox(height: 15,),
            FormField<String>(
              builder: (FormFieldState<String> state) {
                return InputDecorator(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(12, 0, 20, 0),
                    // errorText: "Wrong Choice",
                    errorStyle:
                        const TextStyle(color: Colors.redAccent, fontSize: 16.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontFamily: "verdana_regular",
                      ),
                      hint: Text(
                        widget.hint,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontFamily: "verdana_regular",
                        ),
                      ),
                      items:
                      widget.question.values!.map<DropdownMenuItem<String>>(
                            (String? value) {
                          return DropdownMenuItem(
                            value: value!,
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Icon(valueItem.bank_logo),
                                // const SizedBox(
                                //   width: 15,
                                // ),
                                Text(value),
                              ],
                            ),
                          );
                        },
                      ).toList(),
                      isExpanded: true,
                      isDense: true,
                      onChanged: (String? newSelectedBank) {
                        setState(() {
                          _bankChoose = newSelectedBank!;
                        });
                      },
                      value: _bankChoose,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
