import 'package:fave_reads/controller/reads_controller.dart';

import 'fave_reads.dart';

/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://aqueduct.io/docs/http/channel/.
class FaveReadsChannel extends ApplicationChannel {
  ManagedContext context;
  @override
  Future prepare() async {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));

    final config = ReadConfig(options.configurationFilePath);
    // print(config.database.port);
    // Specify data model
    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();

    // specify the database connection
    final persistentStore = PostgreSQLPersistentStore.fromConnectionInfo(
        config.database.username,
        config.database.password,
        config.database.host,
        config.database.port,
        config.database.databaseName);
       
        
    context = ManagedContext(dataModel, persistentStore);
  }

  /// Construct the request channel.
  ///
  /// Return an instance of some [Controller] that will be the initial receiver
  /// of all [Request]s.
  ///
  /// This method is invoked after [prepare].
  @override
  Controller get entryPoint => Router()
    ..route('/reads/[:id]').link(() => ReadsController(context))
    ..route('/').linkFunction((request) async {
      return Response.ok("Helloo world");
    });
}

class ReadConfig extends Configuration {
  ReadConfig(String path) : super.fromFile(File(path));

  DatabaseConfiguration database;
}
