import 'package:flutter_test/flutter_test.dart';
import 'package:store_management/controllers/controllers.dart';
import 'package:store_management/services/request.dart';

void main() {
  Request buildRequest({required Map<String, dynamic> data}) {
    return Request(title: 'Workflow Request', message: 'Attendance activity audit workflow', data: data);
  }

  test('attendance and activity audit workflow captures staff shift lifecycle', () {
    final shiftsController = StaffShiftsController();
    final attendanceController = StaffAttendanceController();
    final activityController = StaffActivityLogsController();

    const ownerUuid = '11111111-1111-4111-8111-111111111111';
    const branchUuid = '22222222-2222-4222-8222-222222222222';
    const userUuid = '33333333-3333-4333-8333-333333333333';
    const shiftUuid = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa';

    final shiftResponse = shiftsController.create(
      request: buildRequest(
        data: {
          'id': 1,
          'uuid': shiftUuid,
          'ownerUuid': ownerUuid,
          'branchUuid': branchUuid,
          'userUuid': userUuid,
          'shiftDate': 1715122800000,
          'startAt': 1715122800000,
          'endAt': 1715151600000,
          'status': 'in_progress',
        },
      ),
    );

    final attendanceResponse = attendanceController.create(
      request: buildRequest(
        data: {
          'id': 2,
          'ownerUuid': ownerUuid,
          'staffShiftUuid': shiftUuid,
          'checkInAt': 1715122800000,
          'checkOutAt': 1715151600000,
          'minutesWorked': 480,
          'status': 'present',
        },
      ),
    );

    final activityResponse = activityController.create(
      request: buildRequest(
        data: {
          'id': 3,
          'ownerUuid': ownerUuid,
          'branchUuid': branchUuid,
          'userUuid': userUuid,
          'action': 'close_shift',
          'entityType': 'staff_shift',
          'entityUuid': shiftUuid,
          'metadataJson': {
            'workedMinutes': 480,
            'attendanceStatus': 'present',
          },
        },
      ),
    );

    final shiftUpdateResponse = shiftsController.update(
      request: buildRequest(
        data: {
          'id': 1,
          'uuid': shiftUuid,
          'ownerUuid': ownerUuid,
          'branchUuid': branchUuid,
          'userUuid': userUuid,
          'shiftDate': 1715122800000,
          'startAt': 1715122800000,
          'endAt': 1715151600000,
          'status': 'completed',
        },
      ),
    );

    expect(shiftResponse.statusCode, 201);
    expect(attendanceResponse.statusCode, 201);
    expect(activityResponse.statusCode, 201);
    expect(shiftUpdateResponse.statusCode, 200);

    expect(attendanceResponse.data?.minutesWorked, 480);
    expect(activityResponse.data?.entityType, 'staff_shift');
    expect(activityResponse.data?.metadataJson['attendanceStatus'], 'present');
    expect(shiftUpdateResponse.data?.status, 'completed');
  });
}
