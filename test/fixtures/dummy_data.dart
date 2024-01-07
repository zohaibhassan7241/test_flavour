import 'package:test_task_flavours/shared/domain/models/response.dart';
import 'package:test_task_flavours/shared/exceptions/http_exception.dart';

final AppException ktestAppException =
    AppException(message: '', statusCode: 0, identifier: '');

final Response ktestUserResponse =
    Response(statusMessage: 'message', statusCode: 1, data: {});
