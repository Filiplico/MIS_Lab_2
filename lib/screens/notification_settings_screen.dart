import 'package:flutter/material.dart';
import 'package:lab2/services/notification_service.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  final NotificationService _notificationService = NotificationService();
  bool _notificationsEnabled = false;
  TimeOfDay _selectedTime = const TimeOfDay(hour: 18, minute: 0);
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final enabled = await _notificationService.isNotificationEnabled();
    final scheduledTime = await _notificationService.getScheduledTime();
    
    setState(() {
      _notificationsEnabled = enabled;
      if (scheduledTime != null) {
        _selectedTime = scheduledTime;
      }
      _loading = false;
    });
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      helpText: 'Изберете време за нотификација',
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
      if (_notificationsEnabled) {
        await _notificationService.scheduleDailyNotification(picked);
        _showSnackBar('Нотификациите се закажани за ${picked.format(context)}');
      }
    }
  }

  Future<void> _toggleNotifications(bool value) async {
    setState(() {
      _notificationsEnabled = value;
    });

    if (value) {
      await _notificationService.scheduleDailyNotification(_selectedTime);
      _showSnackBar('Нотификациите се овозможени за ${_selectedTime.format(context)}');
    } else {
      await _notificationService.cancelDailyNotification();
      _showSnackBar('Нотификациите се оневозможени');
    }
  }

  Future<void> _testNotification() async {
    await _notificationService.sendTestNotification();
    _showSnackBar('Тест нотификација е испратена');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Поставки за нотификации'),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: SwitchListTile(
                      title: const Text(
                        'Дневни нотификации',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text(
                        'Примајте потсетување секој ден за рандом рецепт',
                      ),
                      value: _notificationsEnabled,
                      onChanged: _toggleNotifications,
                      secondary: const Icon(Icons.notifications),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_notificationsEnabled) ...[
                    Card(
                      child: ListTile(
                        title: const Text(
                          'Време за нотификација',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Тековно време: ${_selectedTime.format(context)}',
                        ),
                        trailing: const Icon(Icons.access_time),
                        onTap: _selectTime,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      child: ListTile(
                        title: const Text(
                          'Тест нотификација',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text(
                          'Испратете тест нотификација за да проверите дали работи',
                        ),
                        trailing: const Icon(Icons.send),
                        onTap: _testNotification,
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Информации',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Кога ќе примите нотификација, притиснете на неа за да видите рандом рецепт на денот.',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

