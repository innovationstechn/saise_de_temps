import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:saise_de_temps/models/form_element_model.dart';

class TimeFormWidget extends StatefulWidget {
  final FormElementModel question;

  const TimeFormWidget({Key? key, required this.question})
      : super(key: key);

  @override
  _TimeFormWidgetState createState() => _TimeFormWidgetState();
}

class _TimeFormWidgetState extends State<TimeFormWidget> {
  String? _hour, _minute, _time;
  String? _setTime;
  TimeOfDay? selectedTime;
  TextEditingController _timeController = TextEditingController();
  double? _width, _height;

  Future _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context, initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(
        () {
          selectedTime = picked;
          _hour = selectedTime!.hour.toString();
          _minute = selectedTime!.minute.toString();
          _time = _hour! + ' : ' + _minute!;
          _timeController.text = _time!;
          _timeController.text = formatDate(
              DateTime(2019, 08, 1, selectedTime!.hour, selectedTime!.minute),
              [hh, ':', nn, " ", am]).toString();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.question.text!),
          InkWell(
            onTap: () {
              _selectTime(context);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              height: _height! / 9,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Colors.grey[200]),
              child: TextFormField(
                style: TextStyle(fontSize: 40),
                textAlign: TextAlign.center,
                onSaved: (String? val) {
                  _setTime = val;
                },
                enabled: false,
                keyboardType: TextInputType.text,
                controller: _timeController,
                decoration: const InputDecoration(
                    disabledBorder:
                        UnderlineInputBorder(borderSide: BorderSide.none),
                    // labelText: 'Time',
                    contentPadding: EdgeInsets.all(5)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
