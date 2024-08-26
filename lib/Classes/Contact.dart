import 'package:url_launcher/url_launcher.dart';

class Contact {
  final int? id; // Added for SQLite operations
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String address;
  final String profilePicture;

  Contact({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.address,
    required this.profilePicture,
  });

  // Convert a Contact into a Map. The keys must correspond to the column names.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'address': address,
      'profilePicture': profilePicture,
    };
  }

  // Extract a Contact object from a Map.
  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      phoneNumber: map['phoneNumber'],
      address: map['address'],
      profilePicture: map['profilePicture'],
    );
  }

  // Complete Name of the Person
  String completeName() {
    return "$firstName $lastName";
  }

  // Function to make a phone call
  Future<void> makePhoneCall() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      // Handle error (e.g., show a message to the user)
      print('Could not launch phone call');
    }
  }
}
