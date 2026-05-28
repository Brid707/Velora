import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class ConfirmDataScreen extends StatelessWidget {
  final String fullName;
  final String username;
  final String email;

  const ConfirmDataScreen({
    Key? key,
    required this.fullName,
    required this.username,
    required this.email,
  }) : super(key: key);

  Widget _buildDataRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Expanded(child: Text(value, style: TextStyle(fontSize: 16))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmar Datos'),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Confirma tus datos',
              style: AppTextStyles.headerStyle(isDark: isDark),
            ),
            const SizedBox(height: 24),
            _buildDataRow('Nombre completo', fullName),
            const SizedBox(height: 16),
            _buildDataRow('Nombre de usuario', username),
            const SizedBox(height: 16),
            _buildDataRow('Correo electrónico', email),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/feed');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Confirmar y continuar'),
            ),
          ],
        ),
      ),
    );
  }
}
