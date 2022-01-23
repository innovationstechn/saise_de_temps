import 'package:flutter/material.dart';
import 'package:saise_de_temps/models/form_element_model.dart';
import 'package:saise_de_temps/pages/form_page_viewmodel.dart';
import 'package:saise_de_temps/widgets/checkbox_form_widget.dart';
import 'package:saise_de_temps/widgets/time_form_widget.dart';
import 'package:saise_de_temps/widgets/dropdown_form_widget.dart';
import 'package:saise_de_temps/widgets/text_form_widget.dart';
import 'package:stacked/stacked.dart';

class FormPage extends StatelessWidget {
  const FormPage({Key? key}) : super(key: key);

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

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Form(
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
                                return TextFormWidget(question: item);
                              case FormElementType.number:
                                return TextFormWidget(
                                  question: item,
                                  textType: TextInputType.number,
                                );

                              case FormElementType.multiple:
                                return DropDownFormWidget(
                                  question: item,
                                );
                              case FormElementType.checkbox:
                                return CheckboxIconFormField(
                                  question: item,
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 0, 5, 0),
                                );
                              case FormElementType.time:
                                return TimeFormWidget(question: item);
                              case FormElementType.unknown:
                                return Text(item.text!);
                            }
                          },
                        ),
                        buildSubmitButton(),
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
            );
          },
        ),
      ),
    );
  }

  Widget buildSubmitButton() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
        child: ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Color.fromARGB(255, 30, 48, 62),
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
                    Color.fromARGB(255, 30, 48, 62),
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
        color: Color.fromARGB(255, 30, 48, 62),
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Saise-De-Temps',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 10,),
            Text(
              'v0.0.1',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      );
}
