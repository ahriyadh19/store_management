import 'package:store_management/models/status_info.dart';

Map<int, StatusInfo> statusCatalog = {
  0: StatusInfo(name: 'inactive', bgColor: 'bg-red-100', textColor: 'text-red-800', borderColor: 'border-red-300', icon: 'assets/icons/inactive.svg'),
  1: StatusInfo(name: 'active', bgColor: 'bg-green-100', textColor: 'text-green-800', borderColor: 'border-green-300', icon: 'assets/icons/active.svg'),
  2: StatusInfo(name: 'pending', bgColor: 'bg-yellow-100', textColor: 'text-yellow-800', borderColor: 'border-yellow-300', icon: 'assets/icons/pending.svg'),
  3: StatusInfo(name: 'draft', bgColor: 'bg-gray-100', textColor: 'text-gray-800', borderColor: 'border-gray-300', icon: 'assets/icons/draft.svg'),
  4: StatusInfo(name: 'completed', bgColor: 'bg-blue-100', textColor: 'text-blue-800', borderColor: 'border-blue-300', icon: 'assets/icons/completed.svg'),
};

StatusInfo? statusInfoFor(int code) => statusCatalog[code];

final Map<int, Map<String, String>> status = Map<int, Map<String, String>>.unmodifiable(statusCatalog.map((code, info) => MapEntry(code, info.toMap())));
