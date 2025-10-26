class Country {
  final String name;
  final String countryCode;
  final String dialCode;
  final String flag;

  Country({
    required this.name,
    required this.countryCode,
    required this.dialCode,
    required this.flag,
  });
}

final List<Country> countries = [
  Country(
    name: 'United States',
    countryCode: 'US',
    dialCode: '+1',
    flag: '🇺🇸',
  ),
  Country(
    name: 'United Kingdom',
    countryCode: 'GB',
    dialCode: '+44',
    flag: '🇬🇧',
  ),
  Country(name: 'Canada', countryCode: 'CA', dialCode: '+1', flag: '🇨🇦'),
  Country(name: 'Australia', countryCode: 'AU', dialCode: '+61', flag: '🇦🇺'),
  Country(name: 'India', countryCode: 'IN', dialCode: '+91', flag: '🇮🇳'),
  Country(
    name: 'United Arab Emirates',
    countryCode: 'AE',
    dialCode: '+971',
    flag: '🇦🇪',
  ),
  Country(
    name: 'Saudi Arabia',
    countryCode: 'SA',
    dialCode: '+966',
    flag: '🇸🇦',
  ),
];
