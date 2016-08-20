import std.socket;
import std.stdio;
import std.file;

void main() {

   auto listener = new Socket(AddressFamily.INET, SocketType.STREAM);
   listener.bind(new InternetAddress("192.168.0.17", 6665));
   listener.listen(10);

   char [1024] buffer;
   char[1024] name;

   Socket client;

   bool isRunning = true;

   while(isRunning) {

      client = listener.accept();
      client.send("Conectado!");

      auto len = client.receive(name);

      auto stream = File(name[0 .. len], "w+");


      auto got = client.receive(buffer);

      while(got != 0) {
          stream.rawWrite(buffer[0 .. got]);
    		  got = client.receive(buffer[0 .. got]);
      }

  }


}
