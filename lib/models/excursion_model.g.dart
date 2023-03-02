// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'excursion_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ExcursionCWProxy {
  Excursion excursionCode(String excursionCode);

  Excursion color(Color color);

  Excursion excursionTipe(ExcursionTipe excursionTipe);

  Excursion excursionStart(DateTime excursionStart);

  Excursion excursionEnd(DateTime excursionEnd);

  Excursion maxPassengers(int maxPassengers);

  Excursion reservations(List<Reservation>? reservations);

  Excursion reservationsReference(List<dynamic>? reservationsReference);

  Excursion createdAt(DateTime createdAt);

  Excursion updatedAt(DateTime updatedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Excursion(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Excursion(...).copyWith(id: 12, name: "My name")
  /// ````
  Excursion call({
    String? excursionCode,
    Color? color,
    ExcursionTipe? excursionTipe,
    DateTime? excursionStart,
    DateTime? excursionEnd,
    int? maxPassengers,
    List<Reservation>? reservations,
    List<dynamic>? reservationsReference,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfExcursion.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfExcursion.copyWith.fieldName(...)`
class _$ExcursionCWProxyImpl implements _$ExcursionCWProxy {
  const _$ExcursionCWProxyImpl(this._value);

  final Excursion _value;

  @override
  Excursion excursionCode(String excursionCode) =>
      this(excursionCode: excursionCode);

  @override
  Excursion color(Color color) => this(color: color);

  @override
  Excursion excursionTipe(ExcursionTipe excursionTipe) =>
      this(excursionTipe: excursionTipe);

  @override
  Excursion excursionStart(DateTime excursionStart) =>
      this(excursionStart: excursionStart);

  @override
  Excursion excursionEnd(DateTime excursionEnd) =>
      this(excursionEnd: excursionEnd);

  @override
  Excursion maxPassengers(int maxPassengers) =>
      this(maxPassengers: maxPassengers);

  @override
  Excursion reservations(List<Reservation>? reservations) =>
      this(reservations: reservations);

  @override
  Excursion reservationsReference(List<dynamic>? reservationsReference) =>
      this(reservationsReference: reservationsReference);

  @override
  Excursion createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  Excursion updatedAt(DateTime updatedAt) => this(updatedAt: updatedAt);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Excursion(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Excursion(...).copyWith(id: 12, name: "My name")
  /// ````
  Excursion call({
    Object? excursionCode = const $CopyWithPlaceholder(),
    Object? color = const $CopyWithPlaceholder(),
    Object? excursionTipe = const $CopyWithPlaceholder(),
    Object? excursionStart = const $CopyWithPlaceholder(),
    Object? excursionEnd = const $CopyWithPlaceholder(),
    Object? maxPassengers = const $CopyWithPlaceholder(),
    Object? reservations = const $CopyWithPlaceholder(),
    Object? reservationsReference = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
  }) {
    return Excursion(
      excursionCode:
          excursionCode == const $CopyWithPlaceholder() || excursionCode == null
              // ignore: unnecessary_non_null_assertion
              ? _value.excursionCode!
              // ignore: cast_nullable_to_non_nullable
              : excursionCode as String,
      color: color == const $CopyWithPlaceholder() || color == null
          // ignore: unnecessary_non_null_assertion
          ? _value.color!
          // ignore: cast_nullable_to_non_nullable
          : color as Color,
      excursionTipe:
          excursionTipe == const $CopyWithPlaceholder() || excursionTipe == null
              // ignore: unnecessary_non_null_assertion
              ? _value.excursionTipe!
              // ignore: cast_nullable_to_non_nullable
              : excursionTipe as ExcursionTipe,
      excursionStart: excursionStart == const $CopyWithPlaceholder() ||
              excursionStart == null
          // ignore: unnecessary_non_null_assertion
          ? _value.excursionStart!
          // ignore: cast_nullable_to_non_nullable
          : excursionStart as DateTime,
      excursionEnd:
          excursionEnd == const $CopyWithPlaceholder() || excursionEnd == null
              // ignore: unnecessary_non_null_assertion
              ? _value.excursionEnd!
              // ignore: cast_nullable_to_non_nullable
              : excursionEnd as DateTime,
      maxPassengers:
          maxPassengers == const $CopyWithPlaceholder() || maxPassengers == null
              // ignore: unnecessary_non_null_assertion
              ? _value.maxPassengers!
              // ignore: cast_nullable_to_non_nullable
              : maxPassengers as int,
      reservations: reservations == const $CopyWithPlaceholder()
          ? _value.reservations
          // ignore: cast_nullable_to_non_nullable
          : reservations as List<Reservation>?,
      reservationsReference:
          reservationsReference == const $CopyWithPlaceholder()
              ? _value.reservationsReference
              // ignore: cast_nullable_to_non_nullable
              : reservationsReference as List<dynamic>?,
      createdAt: createdAt == const $CopyWithPlaceholder() || createdAt == null
          // ignore: unnecessary_non_null_assertion
          ? _value.createdAt!
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      updatedAt: updatedAt == const $CopyWithPlaceholder() || updatedAt == null
          // ignore: unnecessary_non_null_assertion
          ? _value.updatedAt!
          // ignore: cast_nullable_to_non_nullable
          : updatedAt as DateTime,
    );
  }
}

extension $ExcursionCopyWith on Excursion {
  /// Returns a callable class that can be used as follows: `instanceOfExcursion.copyWith(...)` or like so:`instanceOfExcursion.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ExcursionCWProxy get copyWith => _$ExcursionCWProxyImpl(this);
}
