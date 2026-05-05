import 'package:flutter/material.dart';
import 'package:store_management/models/status_info.dart';

Map<int, StatusInfo> statusCatalog = {
  0: StatusInfo(name: 'inactive', bgColor: 'bg-red-100', textColor: 'text-red-800', borderColor: 'border-red-300', icon: 'block_rounded'),
  1: StatusInfo(name: 'active', bgColor: 'bg-green-100', textColor: 'text-green-800', borderColor: 'border-green-300', icon: 'check_circle_rounded'),
  2: StatusInfo(name: 'pending', bgColor: 'bg-yellow-100', textColor: 'text-yellow-800', borderColor: 'border-yellow-300', icon: 'schedule_rounded'),
  3: StatusInfo(name: 'draft', bgColor: 'bg-gray-100', textColor: 'text-gray-800', borderColor: 'border-gray-300', icon: 'edit_note_rounded'),
  4: StatusInfo(name: 'completed', bgColor: 'bg-blue-100', textColor: 'text-blue-800', borderColor: 'border-blue-300', icon: 'task_alt_rounded'),
};

StatusInfo? statusInfoFor(int code) => statusCatalog[code];

IconData statusIconFor(int code) {
  switch (code) {
    case 0:
      return Icons.block_rounded;
    case 1:
      return Icons.check_circle_rounded;
    case 2:
      return Icons.schedule_rounded;
    case 3:
      return Icons.edit_note_rounded;
    case 4:
      return Icons.task_alt_rounded;
    default:
      return Icons.help_outline_rounded;
  }
}

Color statusBackgroundColorFor(int code) {
  final token = statusInfoFor(code)?.bgColor;
  return _statusColorFromToken(token, fallback: const Color(0xFFF3F4F6));
}

Color statusTextColorFor(int code) {
  final token = statusInfoFor(code)?.textColor;
  return _statusColorFromToken(token, fallback: const Color(0xFF1F2937));
}

Color statusBorderColorFor(int code) {
  final token = statusInfoFor(code)?.borderColor;
  return _statusColorFromToken(token, fallback: const Color(0xFFD1D5DB));
}

Color _statusColorFromToken(String? token, {required Color fallback}) {
  switch (token) {
    case 'bg-red-100':
      return const Color(0xFFFEE2E2);
    case 'text-red-800':
      return const Color(0xFF991B1B);
    case 'border-red-300':
      return const Color(0xFFFCA5A5);
    case 'bg-green-100':
      return const Color(0xFFDCFCE7);
    case 'text-green-800':
      return const Color(0xFF166534);
    case 'border-green-300':
      return const Color(0xFF86EFAC);
    case 'bg-yellow-100':
      return const Color(0xFFFEF9C3);
    case 'text-yellow-800':
      return const Color(0xFF854D0E);
    case 'border-yellow-300':
      return const Color(0xFFFDE047);
    case 'bg-gray-100':
      return const Color(0xFFF3F4F6);
    case 'text-gray-800':
      return const Color(0xFF1F2937);
    case 'border-gray-300':
      return const Color(0xFFD1D5DB);
    case 'bg-blue-100':
      return const Color(0xFFDBEAFE);
    case 'text-blue-800':
      return const Color(0xFF1E40AF);
    case 'border-blue-300':
      return const Color(0xFF93C5FD);
    default:
      return fallback;
  }
}

String statusLabelFor(int code, {required bool isArabic}) {
  if (isArabic) {
    switch (code) {
      case 0:
        return 'غير نشط';
      case 1:
        return 'نشط';
      case 2:
        return 'قيد الانتظار';
      case 3:
        return 'مسودة';
      case 4:
        return 'مكتمل';
      default:
        return 'غير معروف';
    }
  }

  switch (code) {
    case 0:
      return 'Inactive';
    case 1:
      return 'Active';
    case 2:
      return 'Pending';
    case 3:
      return 'Draft';
    case 4:
      return 'Completed';
    default:
      return 'Unknown';
  }
}

final Map<int, Map<String, String>> status = Map<int, Map<String, String>>.unmodifiable(statusCatalog.map((code, info) => MapEntry(code, info.toMap())));
