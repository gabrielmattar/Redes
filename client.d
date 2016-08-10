import std.socket;
import std.stdio;

void main() {
    auto socket = new Socket(AddressFamily.INET,  SocketType.STREAM);
    char[1024] buffer;

    socket.connect(new InternetAddress("localhost", 2525));

    auto received = socket.receive(buffer); // wait for the server to say hello

    writeln("Server said: ", buffer[0 .. received]);
    foreach(line; stdin.byLine) {
       socket.send(line);
       writeln("Server said: ", buffer[0 .. socket.receive(buffer)]);
    }

}