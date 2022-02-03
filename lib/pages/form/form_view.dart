import 'package:flutter/material.dart';
import 'package:saise_de_temps/constants/colors.dart';
import 'package:saise_de_temps/models/checkbox_options_model.dart';
import 'package:saise_de_temps/models/form_element_model.dart';
import 'package:saise_de_temps/pages/form/form_viewmodel.dart';
import 'package:saise_de_temps/widgets/checkbox_form_widget.dart';
import 'package:saise_de_temps/widgets/dropdown_form_widget.dart';
import 'package:saise_de_temps/widgets/text_form_widget.dart';
import 'package:saise_de_temps/widgets/time_form_widget.dart';
import 'package:stacked/stacked.dart';

class FormView extends StatelessWidget {
  FormView({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ViewModelBuilder.reactive(
          viewModelBuilder: () => FormPageVM(),
          onModelReady: (FormPageVM model) => model.loadData(),
          builder: (context, FormPageVM formVM, _) {
            if (formVM.hasError) {
              return onErrorWidget(
                formVM.error(formVM),
                formVM.loadData,
                formVM.onSettingsPressed,
              );
            }

            if (formVM.isBusy) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () {
                return formVM.loadData();
              },
              color: primaryColor,
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
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              FormElementModel item = formVM.questions[index];
                              switch (item.formType) {
                                case FormElementType.text:
                                  return TextFormWidget(
                                    question: item,
                                    context: context,
                                    textEditingController:
                                        TextEditingController(),
                                  );
                                case FormElementType.number:
                                  return TextFormWidget(
                                    question: item,
                                    context: context,
                                    textEditingController:
                                        TextEditingController(),
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
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 0, 5, 0),
                                  );
                                case FormElementType.unknown:
                                  return Text(item.text!);
                              }
                            },
                          ),
                          if (!formVM.isBusy)
                            buildSubmitButton(context, formVM.submit)
                          else
                            const CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          buildExtraOptionsTray(
                              formVM.resync, formVM.onSettingsPressed),
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

  Widget buildSubmitButton(BuildContext context,
          void Function(List<Map<String, dynamic>>) onTap) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
        child: ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              // await DB.db.addForm();
              onTap([]);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Validation false"),
                ),
              );
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
              Icon(Icons.done),
              SizedBox(
                width: 5,
              ),
              Text('SUBMIT THE APPLICATION'),
            ],
          ),
        ),
      );

  Widget buildExtraOptionsTray(
          void Function() onResyncTap, Future Function() onSettingsTap) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    primaryColor,
                  ),
                  foregroundColor: MaterialStateProperty.all(
                    Colors.white,
                  ),
                ),
                onPressed: () => onResyncTap(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.sync),
                    SizedBox(
                      width: 5,
                    ),
                    Text('FORCE RESYNC'),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            GestureDetector(
              onTap: onSettingsTap,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      color: Colors.grey,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  child: Icon(Icons.settings),
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildFooter() => Container(
        height: 100,
        width: double.infinity,
        color: primaryColor,
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

  Widget onErrorWidget(String errorMsg, void Function() onRefreshTap,
          void Function() onSettingsTap) =>
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              errorMsg,
              style: const TextStyle(fontSize: 16),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(primaryColor),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.refresh),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'REFRESH',
                  ),
                ],
              ),
              onPressed: onRefreshTap,
            ),
            const SizedBox(
              width: 15,
            ),
            GestureDetector(
              onTap: onSettingsTap,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      color: Colors.grey,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  child: Icon(Icons.settings),
                ),
              ),
            ),
          ],
        ),
      );
}
