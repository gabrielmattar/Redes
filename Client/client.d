import std.socket;
import std.stdio;
import std.file;

void main() {
    auto socket = new Socket(AddressFamily.INET,  SocketType.STREAM);
    char[1024] buffer;

    socket.connect(new InternetAddress("localhost", 6666));

    auto received = socket.receive(buffer); // wait for the server to say hello

    writeln(buffer[0 .. received]);
    foreach(char [] line; stdin.byLine) {


      auto stream = File(line, "r+");
      socket.send(line[0 .. line.length]);



      auto inbytes = new char[1024];

      auto inteiro = stream.size()/1024;
      inteiro = inteiro * 1024;

      auto resto = stream.size() - inteiro;

      //Enviando pedacos do arquivo
      for(int i = 0; i < stream.size()/1024; i++){
        stream.rawRead(inbytes);
        socket.send(inbytes);
      }

      //Enviando bytes finais do arquivo
      inbytes = new char[resto];
      stream.rawRead(inbytes);
      socket.send(inbytes);

      //writeln(buffer[0 .. socket.receive(buffer)]);
    }

}
