import 'package:flutter/material.dart';
import 'package:saise_de_temps/models/checkbox_options_model.dart';
import 'package:saise_de_temps/models/form_element_model.dart';
import 'package:saise_de_temps/pages/form_page_viewmodel.dart';
import 'package:saise_de_temps/services/database/db.dart';
import 'package:saise_de_temps/services/database/hive_db.dart';
import 'package:saise_de_temps/widgets/checkbox_form_widget.dart';
import 'package:saise_de_temps/widgets/dropdown_form_widget.dart';
import 'package:saise_de_temps/widgets/text_form_widget.dart';
import 'package:saise_de_temps/widgets/time_form_widget.dart';
import 'package:stacked/stacked.dart';

class FormPage extends StatelessWidget{
  FormPage({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ViewModelBuilder.reactive(
          viewModelBuilder: () => FormPageVM(),
          onModelReady: (FormPageVM model) => model.loadData(),
          builder: (context, FormPageVM formVM, _) {
            if (formVM.isBusy) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return RefreshIndicator(
              onRefresh: () {
                return formVM.loadData();
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          ListView.builder(
                            itemCount: formVM.questions.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              FormElementModel item = formVM.questions[index];
                              switch (item.formType) {
                                case FormElementType.text:
                                  return TextFormWidget(
                                    question: item,
                                    context: context,
                                    textEditingController: TextEditingController(),
                                  );
                                case FormElementType.number:
                                  return TextFormWidget(
                                    question: item,
                                    context: context,
                                    textEditingController: TextEditingController(),
                                  );
                                case FormElementType.time:
                                  return TimeSelectionFormField(
                                    question: item,
                                    context: context,
                                  );
                                case FormElementType.multiple:
                                  return DropDownFormField(
                                    question: item,
                                    context: context,
                                  );
                                case FormElementType.checkbox:
                                  CheckBoxOptionModel checkboxOptionModel =
                                  item.getCheckBoxModel();
                                  return CheckboxIconFormField(
                                    question: item,
                                    checkBoxOptionModel: checkboxOptionModel,
                                    initialValue: checkboxOptionModel.value,
                                    padding: const EdgeInsets.fromLTRB(15, 0, 5, 0),
                                  );
                                case FormElementType.unknown:
                                  return Text(item.text!);
                              }
                            },
                          ),
                          buildSubmitButton(context),
                          buildExtraOptionsTray(),
                        ],
                      ),
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    // fillOverscroll: true, // Set true to change overscroll behavior. Purely preference.
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: buildFooter(),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildSubmitButton(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
        child: ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              await DB.db.addForm();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Validation false")));
            }
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              const Color.fromARGB(255, 30, 48, 62),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('SUBMIT THE APPLICATION'),
            ],
          ),
        ),
      );

  Widget buildExtraOptionsTray() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 30, 48, 62),
                  ),
                ),
                onPressed: () {},
                child: const Text('FORCE RESYNC'),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            const CircleAvatar(
              backgroundColor: Color.fromARGB(255, 30, 48, 62),
              foregroundColor: Colors.white,
              child: Icon(Icons.settings),
            ),
          ],
        ),
      );

  Widget buildFooter() => Container(
        height: 100,
        width: double.infinity,
        color: const Color.fromARGB(255, 30, 48, 62),
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Saise-De-Temps',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'v0.0.1',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      );
}
