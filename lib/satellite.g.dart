// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'satellite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Satellite _$SatelliteFromJson(Map<String, dynamic> json) => Satellite(
      json['satid'] as int,
      json['satname'] as String,
      json['intDesignator'] as String,
      json['launchDate'] as String,
      (json['satlat'] as num).toDouble(),
      (json['satlng'] as num).toDouble(),
      (json['satalt'] as num).toDouble(),
    );
