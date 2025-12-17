import 'package:flutter/material.dart';
import 'package:quorocare4/appointments/style/styles.dart';
import 'package:quorocare4/appointments/widget/appointment_card.dart'; 

class AppointmentDetailsView extends StatelessWidget {
  final Appointment appointment;

  const AppointmentDetailsView({Key? key, required this.appointment})
    : super(key: key);

  // --- FIX START: Definition of _buildStatusLabel ---
  Widget _buildStatusLabel(String status) {
    Color displayColor = AppColors.backgroundGrey; // Default/Fallback

    if (status == 'On the way') {
      displayColor = AppColors.statusLabelColorOnTheWay; // Dark Purple
    } else if (status == 'Confirmed' || status == 'Completed') {
      displayColor = AppColors.statusLabelColorConfirmed; // Bright Teal/Green
    } else if (status == 'Cancelled') {
      displayColor = Colors.red.shade600;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: displayColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(status, style: AppFonts.statusLabel),
    );
  }
  // --- FIX END ---

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor ?? AppColors.primaryBlue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppFonts.subtleText.copyWith(color: Colors.black54),
                ),
                Text(value, style: AppFonts.bodyText),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Mimics the vertical timeline from the second screenshot
  Widget _buildTimelineStep({
    required String title,
    required String subtitle,
    required bool isLast,
    required bool isDone,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isDone
                    ? AppColors.activeGreen
                    : AppColors.backgroundGrey,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDone ? AppColors.activeGreen : AppColors.subtleText,
                  width: 1,
                ),
              ),
              child: isDone
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 50,
                color: isDone ? AppColors.activeGreen : AppColors.subtleText,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppFonts.bodyText.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(subtitle, style: AppFonts.subtleText),
              if (isLast) const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBillDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('BILL DETAILS', style: AppFonts.cardTitle),
          const Divider(),
          _buildBillRow('Total', 'Rs 1600', isTotal: true),
          const SizedBox(height: 8),
          _buildBillRow('Home doctor consultation', 'Rs 1499'),
          _buildBillRow('Glucose Test', 'Rs 100'),
          const Divider(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildBillRow(String label, String amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? AppFonts.cardTitle.copyWith(fontSize: 18)
                : AppFonts.bodyText,
          ),
          Text(
            amount,
            style: isTotal
                ? AppFonts.cardTitle.copyWith(fontSize: 18)
                : AppFonts.bodyText,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    final bool isCompleted = appointment.status == 'Completed';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.darkText),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(appointment.title),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.darkText,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: _buildStatusLabel(appointment.status),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment.date.split('.').first,
                    style: AppFonts.heading1,
                  ),
                  const SizedBox(height: 4),
                  _buildDetailRow(
                    icon: Icons.calendar_month,
                    title: 'General Consultation',
                    value: 'Booking id #90848894833',
                  ),
                  _buildDetailRow(
                    icon: Icons.person,
                    title: 'Dr. Asinsha',
                    value: 'General Practitioner',
                    iconColor: Colors.purple,
                  ),
                ],
              ),
            ),
            const Divider(),

            // Booked For Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('BOOKED FOR :', style: AppFonts.bodyText),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.account_circle,
                        color: AppColors.darkText,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Ashish R (Self) • 34 yrs • Male',
                        style: AppFonts.cardTitle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),

            // Timeline
            Padding(
              padding: const EdgeInsets.fromLTRB(26.0, 16.0, 16.0, 16.0),
              child: Column(
                children: [
                  _buildTimelineStep(
                    title: 'Appointment Booked',
                    subtitle: 'Booked on 13 Jul 2025, 10:00AM',
                    isLast: false,
                    isDone: true,
                  ),
                  _buildTimelineStep(
                    title: 'Confirmed',
                    subtitle: 'Qurocare clinics, Pattom - Ulloor, Trivandrum',
                    isLast: false,
                    isDone: true,
                  ),
                  _buildTimelineStep(
                    title: 'Care Unit Assigned',
                    subtitle:
                        'To Ashish R, Vattapramcode, Vellanadu Nedumangad Road, Kerala India',
                    isLast: isCompleted ? false : true,
                    isDone: true,
                  ),
                  if (isCompleted)
                    _buildTimelineStep(
                      title: 'Completed Consultation',
                      subtitle:
                          'Care delivered on 14 Jul 2025, 12:20AM by Dr Asinsha',
                      isLast: true,
                      isDone: true,
                    ),
                  const SizedBox(height: 20),

                  if (isCompleted)
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: AppColors.lightText,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'View Medical Records',
                        style: AppFonts.cardTitle,
                      ),
                    ),
                ],
              ),
            ),
            const Divider(),

            _buildBillDetails(),
          ],
        ),
      ),
    );
  }
}
