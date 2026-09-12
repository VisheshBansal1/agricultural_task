import '../core/constants.dart';

class BookingItem {
  final String id;
  final String userId;
  final String userName;
  final String resourceId;
  final String resourceName;
  final String ownerId;
  final DateTime startDate;
  final DateTime endDate;
  final double rentalAmount;
  final double deposit;
  final BookingStatus status;
  final String location;
  final DateTime requestDate;
  final String? rejectionReason;

  const BookingItem({
    required this.id,
    required this.userId,
    required this.userName,
    required this.resourceId,
    required this.resourceName,
    required this.ownerId,
    required this.startDate,
    required this.endDate,
    required this.rentalAmount,
    required this.deposit,
    required this.status,
    required this.location,
    required this.requestDate,
    this.rejectionReason,
  });

  int get durationDays => endDate.difference(startDate).inDays + 1;
  double get totalAmount => rentalAmount + deposit;

  BookingItem copyWith({BookingStatus? status, String? rejectionReason}) {
    return BookingItem(
      id: id,
      userId: userId,
      userName: userName,
      resourceId: resourceId,
      resourceName: resourceName,
      ownerId: ownerId,
      startDate: startDate,
      endDate: endDate,
      rentalAmount: rentalAmount,
      deposit: deposit,
      status: status ?? this.status,
      location: location,
      requestDate: requestDate,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }
}
