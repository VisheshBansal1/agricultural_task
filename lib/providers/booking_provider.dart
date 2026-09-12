import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../mock_data/mock_bookings.dart';
import '../models/booking.dart';
import '../models/resource.dart';

class BookingProvider extends ChangeNotifier {
  final List<BookingItem> _bookings = List.of(mockBookings);

  ResourceItem? draftResource;
  DateTime? draftStart;
  DateTime? draftEnd;

  List<BookingItem> get bookings => List.unmodifiable(_bookings);

  List<BookingItem> forUser(String userId) =>
      _bookings.where((b) => b.userId == userId).toList()
        ..sort((a, b) => b.requestDate.compareTo(a.requestDate));

  List<BookingItem> forOwner(String ownerId) =>
      _bookings.where((b) => b.ownerId == ownerId).toList()
        ..sort((a, b) => b.requestDate.compareTo(a.requestDate));

  List<BookingItem> byStatus(BookingStatus status) =>
      _bookings.where((b) => b.status == status).toList();

  List<BookingItem> get pendingForAdmin =>
      _bookings.where((b) => b.status == BookingStatus.pending).toList();

  void startDraft(ResourceItem resource) {
    draftResource = resource;
    draftStart = null;
    draftEnd = null;
  }

  void setDraftDates(DateTime start, DateTime end) {
    draftStart = start;
    draftEnd = end;
    notifyListeners();
  }

  double get draftDuration {
    if (draftStart == null || draftEnd == null) return 0;
    return draftEnd!.difference(draftStart!).inDays + 1;
  }

  double get draftRentalAmount {
    if (draftResource == null) return 0;
    final days = draftDuration;
    switch (draftResource!.pricingType) {
      case PricingType.daily:
        return draftResource!.price * days;
      case PricingType.weekly:
        return draftResource!.price * (days / 7).ceil();
      case PricingType.monthly:
        return draftResource!.price * (days / 30).ceil();
      case PricingType.custom:
        return draftResource!.price * days;
    }
  }

  BookingItem submitDraftBooking(String userId, String userName) {
    final booking = BookingItem(
      id: 'b${_bookings.length + 1}_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      userName: userName,
      resourceId: draftResource!.id,
      resourceName: draftResource!.name,
      ownerId: draftResource!.ownerId,
      startDate: draftStart!,
      endDate: draftEnd!,
      rentalAmount: draftRentalAmount,
      deposit: draftResource!.securityDeposit,
      status: BookingStatus.pending,
      location: draftResource!.location,
      requestDate: DateTime.now(),
    );
    _bookings.insert(0, booking);
    notifyListeners();
    return booking;
  }

  void updateStatus(String bookingId, BookingStatus status, {String? reason}) {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index == -1) return;
    _bookings[index] = _bookings[index].copyWith(status: status, rejectionReason: reason);
    notifyListeners();
  }

  BookingItem? byId(String id) {
    try {
      return _bookings.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }
}
