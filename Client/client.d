import std.socket;
import std.stdio;
import std.file;

void main() {
    char[1024] buffer;

    foreach(char [] line; stdin.byLine) {

    auto socket = new Socket(AddressFamily.INET,  SocketType.STREAM);
      socket.connect(new InternetAddress("192.168.0.17", 6665));


      // wait for the server to say hello
      auto received = socket.receive(buffer);


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
      inbytes = new char[cast(int)resto];
      stream.rawRead(inbytes);
      socket.send(inbytes);
      socket.close();

    }

}
