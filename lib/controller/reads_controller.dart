import 'package:aqueduct/aqueduct.dart';
import 'package:fave_reads/fave_reads.dart';
import 'package:fave_reads/model/read.dart';

class ReadsController extends ResourceController {
  ReadsController(this.context);
  ManagedContext context;

  @Operation.get()
  Future<Response> getAllReads() async {
    final readQuery = Query<Read>(context);

    return Response.ok(await readQuery.fetch());
  }

  @Operation.get('id')
  Future<Response> getRead(@Bind.path('id') int id) async {
    final readQuery = Query<Read>(context)
      ..where((read) => read.id).equalTo(id);
    final read = await readQuery.fetchOne();
    if (read == null) {
      return Response.notFound(body: 'Item not found.');
    }

    return Response.ok(read);
  }

  @Operation.post()
  Future<Response> createNewReads(@Bind.body() Read body) async {
    final readQuery = Query<Read>(context)..values = body;
    final insertedRead = await readQuery.insert();
    return Response.ok(insertedRead);
  }

  @Operation.put('id')
  Future<Response> updatedRead(
      @Bind.path('id') int id, @Bind.body() Read body) async {
    final readQuery = Query<Read>(context)
      ..values = body
      ..where((read) => read.id).equalTo(id);

    final updatedRead = await readQuery.updateOne();

    if (updatedRead == null) {
      return Response.notFound(body: 'Item not found.');
    }

    return Response.ok(updatedRead);
  }

  @Operation.delete('id')
  Future<Response> deletedRead(@Bind.path('id') int id) async {
    final readQuery = Query<Read>(context)
      ..where((read) => read.id).equalTo(id);
    final deleteCount =  await readQuery.delete();
    if (deleteCount == 0) {
      return Response.notFound(body: 'Item not found.');
    }
    return Response.ok('Deleted read. $deleteCount items');
  }

  // @Operation.delete()
  // Future<Response> deleteReads() async {
  //   return Response.ok("Delete all reads");
  // }

  //   @Operation.get('id')
//   Future<Response> getRead() async {

// String  id = request.path.variables['id'];
// int idInt = int.tryParse(id);
//     if (idInt < 0 || idInt > reads.length) {

//       return Response.notFound(body: 'Item not found.');
//     }
//     // return Response.ok(reads[id]);

//         return Response.ok("id $id == ${reads[idInt].toString()}");
//   }

  // @override
  // FutureOr<RequestOrResponse> handle(Request request) {
  //   switch (request.method) {
  //     case 'GET':
  //       return Response.ok("This is a GET Request");
  //       break;
  //     case 'POST':
  //       return Response.ok("This is a POST Request");
  //       break;
  //     case 'PUT':
  //       return Response.ok("This is a PUT Request");
  //       break;
  //     case 'DELETE':
  //       return Response.ok("This is a DELETE Request");

  //     default:
  //       return Response(
  //           HttpStatus.methodNotAllowed, null, 'Method is not allowed');
  //   }
  // }
}
