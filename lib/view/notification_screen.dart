import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  @override
  Widget build(BuildContext context) { 


    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Notifications',
          style: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    body: Padding(
  padding: const EdgeInsets.all(16.0),
  child: Column(
    children: [
      _notificationItem(
        title: "Booking Confirmed",
        description:
            "Your booking for luggage wrapping (Booking ID: XYZ123) is accepted.",
        date: "12 Nov 2025",
      ),
      const SizedBox(height: 12),
      _notificationItem(
        title: "Delivery Update",
        description:
            "Your package is on the way and will reach you soon. Stay tuned!",
        date: "10 Nov 2025",
      ),
      const SizedBox(height: 12),
      _notificationItem(
        title: "Offer Alert",
        description:
            "You have received a new offer. Check the rewards section now.",
        date: "08 Nov 2025",
      ),
    ],
  ),
),

     
    );
  }

  Widget _notificationItem({
  required String title,
  required String description,
  required String date,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color:  const Color.fromARGB(255, 250, 250, 250),
      borderRadius: BorderRadius.circular(25),
      border: Border.all(color: const Color.fromARGB(255, 197, 197, 197)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          description,
          style: TextStyle(
            fontSize: 11.5,
            color: Colors.grey.shade700,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Text(
          date,
          style: TextStyle(
            fontSize: 10.5,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    ),
  );
}


}
