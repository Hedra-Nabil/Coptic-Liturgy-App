import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/app_state_manager.dart';
import '../../core/utils/constants.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
      ),
      body: Consumer<AppStateManager>(
        builder: (context, appState, child) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Card(
                child: ListTile(
                  leading: Icon(
                    appState.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  ),
                  title: const Text('الوضع الليلي'),
                  trailing: Switch(
                    value: appState.isDarkMode,
                    onChanged: (_) {
                      appState.toggleDarkMode();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'حجم الخط',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: appState.fontSize > AppConstants.minFontSize
                                ? () {
                                    appState.decreaseFontSize();
                                  }
                                : null,
                          ),
                          Text(
                            '${appState.fontSize.toInt()}',
                            style: const TextStyle(fontSize: 18.0),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: appState.fontSize < AppConstants.maxFontSize
                                ? () {
                                    appState.increaseFontSize();
                                  }
                                : null,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'نموذج للنص بالحجم الحالي',
                        style: TextStyle(fontSize: appState.fontSize),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              const Card(
                child: ListTile(
                  leading: Icon(Icons.info),
                  title: Text('عن التطبيق'),
                  subtitle: Text('المكتبة الطقسية - الإصدار 1.0.0'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}