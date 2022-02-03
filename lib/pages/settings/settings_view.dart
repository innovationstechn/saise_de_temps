import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:saise_de_temps/constants/colors.dart';
import 'package:saise_de_temps/pages/settings/settings_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ViewModelBuilder<SettingsVM>.reactive(
        viewModelBuilder: () => SettingsVM(),
        onModelReady: (model) => model.init(),
        builder: (BuildContext context, SettingsVM model, Widget? child) {
          final TextEditingController nameController = TextEditingController()
            ..text = model.username ?? "Not found";
          final TextEditingController configDateController =
              TextEditingController()..text = model.configDate ?? "Not found";
          final TextEditingController stagedFilesCountController =
              TextEditingController()
                ..text = model.stagedResponsesCount?.toString() ?? "0";
          final TextEditingController connStatusController =
              TextEditingController()..text = model.connectionStatus.toString();

          final TextEditingController ipController = TextEditingController()..text = model.ip ?? "";
          final TextEditingController portController = TextEditingController()..text = model.port ?? "";

          if (model.isBusy) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          } else if (model.hasError) {
            return onErrorWidget(
              model.error(model),
              () => model.init(),
            );
          }

          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.settings,
                        size: 40,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Settings',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                staticField(nameController, 'Name'),
                staticField(configDateController, 'Configuration Date'),
                staticField(stagedFilesCountController, 'Files to send'),
                staticField(connStatusController, 'Connection Status'),
                inputField(
                  ipController,
                  'Server IP Address',
                  'XXXX.XXXX.XXXX.XXXX',
                ),
                inputField(
                    portController, 'Server Port', 'Example: 5432 or 10'),
                submitButton(
                  () => model.onOKTapped(
                    ipController.text,
                    portController.text,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget staticField(TextEditingController controller, String label) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: label,
            enabled: false,
          ),
        ),
      );

  Widget inputField(TextEditingController controller, String label, String hint,
          {TextInputFormatter? formatter}) =>
      Padding(
        padding: const EdgeInsets.all(8),
        child: TextField(
          controller: controller,
          inputFormatters: formatter != null ? [formatter] : [],
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: label,
            hintText: hint,
          ),
        ),
      );

  Widget submitButton(void Function() onTap) => Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          width: double.maxFinite,
          child: ElevatedButton(
            onPressed: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.check),
                SizedBox(
                  width: 10,
                ),
                Text('OK'),
              ],
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(primaryColor),
              padding: MaterialStateProperty.all(
                  const EdgeInsets.fromLTRB(8, 16, 12, 16)),
            ),
          ),
        ),
      );

  Widget onErrorWidget(String errorMsg, void Function() onRefreshTap) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
          ],
        ),
      );
}
