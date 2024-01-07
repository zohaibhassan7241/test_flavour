import 'package:test_task_flavours/shared/domain/models/either.dart';
import 'package:test_task_flavours/shared/domain/models/paginated_response.dart';
import 'package:test_task_flavours/shared/exceptions/http_exception.dart';

typedef ResultFuture = Future<Either<AppException, PaginatedResponse>>;
