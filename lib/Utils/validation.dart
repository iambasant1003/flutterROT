

import 'package:geolocator/geolocator.dart';

String? validateDateOfBirth(String? value){
  if (value == null || value.isEmpty) {
    return 'Please enter your date of birth';
  }
  try {
    final parts = value.split('-');
    if (parts.length != 3) throw FormatException();
    final day = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final year = int.parse(parts[2]);
    final dob = DateTime(year, month, day);

    final today = DateTime.now();
    final age = today.year - dob.year -
        ((today.month < dob.month || (today.month == dob.month && today.day < dob.day)) ? 1 : 0);

    if (age < 21) {
      return 'You must be at least 21 years old';
    }else if(age > 56){
      return 'You must be less then 56 years old';
    }
  } catch (e) {
    return 'Enter date in format dd/MM/yyyy';
  }
  return null;
}

String? validateSalaryDate(String? value){
  if (value == null || value.isEmpty) {
    return 'Please enter your next salary date';
  }
  return null;
}

String? validateIndianPinCode(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your PIN code';
  }
  if (!RegExp(r'^[1-9][0-9]{5}$').hasMatch(value)) {
    return 'Enter a valid 6-digit PIN code';
  }
  return null; // ✅ valid
}

String? validatePanCard(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your PAN card number';
  }

  const pattern = r'^[A-Z]{5}[0-9]{4}[A-Z]$';
  final regExp = RegExp(pattern);

  if (!regExp.hasMatch(value)) {
    return 'Enter a valid PAN card number';
  }

  return null; // ✅ valid
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your email';
  }

  // simple and widely used email regex
  const pattern =
      r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$';

  final regExp = RegExp(pattern);

  if (!regExp.hasMatch(value)) {
    return 'Enter a valid email address';
  }

  return null; // ✅ valid
}


String? validateMobileNumber(String? value){
  if (value == null || value.isEmpty) {
    return 'Mobile number cannot be empty';
  }
  if (!RegExp(r'^[6-9][0-9]{9}$')
      .hasMatch(value)) {
    return 'Enter valid 10-digit number';
  }
  return null;
}

String? validateName(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Name is required';
  }

  // Trim and normalize multiple spaces
  String normalized = value.trim().replaceAll(RegExp(r'\s+'), ' ');

  // Match only letters, one space between words, allow dot & apostrophe
  if (!RegExp(r"^[a-zA-Z.'']+( [a-zA-Z.'']+)*$").hasMatch(normalized)) {
    return 'Enter a valid name';
  }

  if (normalized.length < 2) {
    return 'Name must be at least 2 characters long';
  }

  return null;
}

String? validateIfsc(String input) {
  final regex = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
   if(!regex.hasMatch(input.toUpperCase())){
     return "Enter a valid ifsc";
   }
   else{
     return null;
   }
}

String? validateBankName(String? value) {
  final RegExp bankNameRegExp = RegExp(r"^[A-Za-z .'-]{3,}$");
  if (value == null || value.trim().isEmpty) {
    return "Bank name is required";
  } else if (!bankNameRegExp.hasMatch(value.trim())) {
    return "Enter a valid bank name (letters, spaces, . ' - only)";
  }
  return null;
}

String? validateBankAccount(String? value) {
  if (value == null || value.trim().isEmpty) {
    return "Bank account number is required";
  } else if (!RegExp(r'^[1-9][0-9]{8,17}$').hasMatch(value.trim())) {
    return "Enter a valid bank account number (9–18 digits)";
  }
  return null;
}


Future<Position> getCurrentPositionFast() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  // Try last known location first (instant if available)
  Position? lastPosition = await Geolocator.getLastKnownPosition();

  if (lastPosition != null) {
    // Return immediately if we just need "good enough"
    return lastPosition;
  }

  // Otherwise, fetch new position but with a lower timeout
  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.medium, // Medium is much faster
    timeLimit: const Duration(seconds: 5),
  );
}



