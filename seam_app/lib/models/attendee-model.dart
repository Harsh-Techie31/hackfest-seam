class TicketInfo {
  final String ticketId;
  final String attendeeName;
  final String seatNumber;
  final String entranceGate;
  final String contactNumber;
  final String email;
  final String password;
  final String? eventName;
  final String? eventDateTime;

  TicketInfo({
    required this.ticketId,
    required this.attendeeName,
    required this.seatNumber,
    required this.entranceGate,
    required this.contactNumber,
    required this.email,
    required this.password,
    this.eventName,
    this.eventDateTime,
  });

  factory TicketInfo.fromJson(Map<String, dynamic> json) {
    return TicketInfo(
      ticketId: json['ticketId'] ?? '',
      attendeeName: json['name'] ?? '',
      seatNumber: json['seatNumber'] ?? '',
      entranceGate: json['entranceGate'] ?? '',
      contactNumber: json['contactInfo'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      eventName: json['eventName'],
      eventDateTime: json['eventDateTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ticketId': ticketId,
      'name': attendeeName,
      'seatNumber': seatNumber,
      'entranceGate': entranceGate,
      'contactInfo': contactNumber,
      'email': email,
      'password': password,
      'eventName': eventName,
      'eventDateTime': eventDateTime,
    };
  }
}
