import 'package:pharaoh/pharaoh.dart';


final app=Pharaoh();


void main() async{
  app.use((req,res,next){
    next();
  });
  app.get('/foo',(req,res)=>res.ok("bar"));
  app.get('/',(req,res)=>res.ok("<h1>Hello World</h1>"));
  app.get('/app',(req,res)=>res.ok('this'));
  final guestRoute=app.router()
  ..get('/user',(req,res)=>res.ok("Hello world"));


  app.group('/guest', guestRoute);

  await app.listen();
}