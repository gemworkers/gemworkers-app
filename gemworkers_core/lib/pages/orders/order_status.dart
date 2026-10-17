import 'package:flutter/material.dart';

/// Human-readable label for a raw order status ('pending_payment' → 'Awaiting payment').
String orderStatusLabel(String status) => switch (status) {
      'pending_payment' => 'Awaiting payment',
      '' => status,
      _ => status[0].toUpperCase() + status.substring(1).replaceAll('_', ' '),
    };

/// Chip/accent colour for a raw order status.
Color orderStatusColor(String status) => switch (status) {
      'pending_payment' => Colors.amber.shade700,
      'paid'            => Colors.green,
      'confirmed'       => Colors.blue,
      'shipped'         => Colors.orange,
      'received'        => Colors.teal,
      'cancelled'       => Colors.red,
      _                 => Colors.grey,
    };
