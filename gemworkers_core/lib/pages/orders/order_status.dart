import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

/// Human-readable label for a raw order status ('pending_payment' → 'Awaiting payment').
String orderStatusLabel(String status) => switch (status) {
      'pending_payment' => 'Awaiting payment',
      '' => status,
      _ => status[0].toUpperCase() + status.substring(1).replaceAll('_', ' '),
    };

/// Chip/accent colour for a raw order status.
Color orderStatusColor(String status) => switch (status) {
      'pending_payment'                  => AppColors.warning,
      'confirmed' || 'paid' || 'received' => AppColors.success,
      'cancelled'                        => AppColors.error,
      _                                  => AppColors.muted,
    };

/// Chip background for a raw order status (pairs with [orderStatusColor]).
Color orderStatusBackground(String status) => switch (status) {
      'pending_payment' => AppColors.warningBackground,
      _                 => orderStatusColor(status).withValues(alpha: 0.1),
    };
