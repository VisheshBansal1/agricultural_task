import '../models/user.dart';

const AppUser mockCurrentUser = AppUser(
  id: 'u1',
  name: 'Vishesh Sharma',
  phone: '+91 98765 43210',
  email: 'vishesh@example.com',
  location: 'Karnal, Haryana',
  role: AppRole.user,
);

const AppUser mockOwnerUser = AppUser(
  id: 'o1',
  name: 'Ramesh Kumar',
  phone: '+91 91234 56780',
  email: 'ramesh@example.com',
  location: 'Karnal, Haryana',
  role: AppRole.owner,
);

const AppUser mockAdminUser = AppUser(
  id: 'admin1',
  name: 'Admin',
  phone: '+91 90000 00000',
  email: 'admin@krishirent.in',
  location: 'Head Office',
  role: AppRole.admin,
);
