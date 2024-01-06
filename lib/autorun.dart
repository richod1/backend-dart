import 'dart:convert';
import 'dart:io';


void restartProcess(){
    final currentScript=Platform.script.toFilePath();
    Process.start('dart',[currentScript]);
    exit(0);

  }

void main(List<String> arguments) async{
  if(arguments.isEmpty){
    print("Usage: NO file read");
    exit(1);
  }

  final scriptPath=arguments[0];
  Process? runningProcess;
  HttpServer? httpServer;

  Future<void> startProcess() async{

    httpServer=await HttpServer.bind('0.0.0.0',3000);
    runningProcess=await Process.start('dart', [scriptPath]);

    runningProcess!.stdout.transform(utf8.decoder).listen((data){
      print(data);
    });

    runningProcess!.stderr.transform(utf8.decoder).listen((data){
      print(data);
    });

    runningProcess!.exitCode.then((exitCode){
      if(exitCode != 0){
        print('Process existed with error code $exitCode. Restarting...');
        // httpServer?.close();
        // startProcess();
        Future.delayed(const Duration(seconds: 1),(){
          startProcess();
        });
      }
    });

  }
  startProcess();
  


  final watcher=Directory('.').watch();
  watcher.listen((event){
    if(event.path.endsWith('.dart')){
      print("Change detected. Restaring...");
      httpServer?.close();
      runningProcess?.kill(ProcessSignal.sigterm);
      startProcess();
      
    }
  });

}