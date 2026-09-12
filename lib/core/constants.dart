enum BookingStatus {
  pending,
  approved,
  rejected,
  paymentPending,
  confirmed,
  active,
  completed,
  cancelled,
  expired,
}

extension BookingStatusX on BookingStatus {
  String get label {
    switch (this) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.approved:
        return 'Approved';
      case BookingStatus.rejected:
        return 'Rejected';
      case BookingStatus.paymentPending:
        return 'Payment Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.active:
        return 'Active';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.expired:
        return 'Expired';
    }
  }
}

enum ResourceStatus { pendingApproval, listed, rejected, disabled }

enum PricingType { daily, weekly, monthly, custom }

extension PricingTypeX on PricingType {
  String get label {
    switch (this) {
      case PricingType.daily:
        return '/day';
      case PricingType.weekly:
        return '/week';
      case PricingType.monthly:
        return '/month';
      case PricingType.custom:
        return '/custom';
    }
  }
}

const List<String> kDistanceFilters = ['5 km', '10 km', '25 km', '50 km'];

const List<String> kPaymentMethods = ['UPI', 'Card', 'Wallet'];
