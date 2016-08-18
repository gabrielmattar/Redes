import std.socket;
import std.stdio;
import std.file;

void main() {

   auto listener = new Socket(AddressFamily.INET, SocketType.STREAM);
   listener.bind(new InternetAddress("localhost", 6666));
   listener.listen(10);

   auto readSet = new SocketSet();
   Socket[] connectedClients;
   char[1024] buffer;
   char[1024] name;

   bool isRunning = true;

   while(isRunning) {
       readSet.reset();
       readSet.add(listener);
       foreach(client; connectedClients) readSet.add(client);
       if(Socket.select(readSet, null, null)) {
          foreach(client; connectedClients)
            if(readSet.isSet(client)){

              auto len = client.receive(name);

              auto stream = File(name[0 .. len], "w+");


              auto got = client.receive(buffer);

              while(got == 1024) {
                  // read from it and echo it back

                  stream.rawWrite(buffer[0 .. got]);
                  got = client.receive(buffer);
              }
              writeln("Recebido");

            }
          if(readSet.isSet(listener)) {
             // the listener is ready to read, that means
             // a new client wants to connect. We accept it here.
             auto newSocket = listener.accept();
             newSocket.send("Conectado!"); // say hello
             connectedClients ~= newSocket; // add to our list
          }
       }
   }

}
