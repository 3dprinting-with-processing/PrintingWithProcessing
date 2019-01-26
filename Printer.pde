import processing.serial.*;
import java.util.Queue;
import java.util.ArrayDeque;

public class Printer {
  PApplet app;
  Serial serial;
  Queue<String> q = new ArrayDeque();
  boolean ready = false;

  Printer(PApplet app, String deviceName, int deviceSpeed) {
    this.app = app;
    serial = new Serial(app, deviceName, deviceSpeed);
    registerMethod("pre", this);
  }

  void send(String cmd) {
    //strip ; comments
    if (cmd.indexOf(";")>=0) {
      cmd = cmd.substring(0, max(0, cmd.indexOf(";")-1));
    }
    //strip ( comments
    if (cmd.indexOf("(")>=0) {
      cmd = cmd.substring(0, max(0, cmd.indexOf("(")-1));
    }    
    cmd = trim(cmd);
    if (cmd.length()>0) {
      q.add(cmd);
    }
  }

  public void pre() { // runs before draw()
    while (serial.available() > 0) {
      String response = serial.readStringUntil('\n');   
      if (response != null) parseResponse(trim(response));
    }

    if (millis()>5000 && ready && q.size()>0) {
      ready = false;
      String cmd = q.poll();
      println("> " + cmd);
      serial.write(cmd + '\n');
    }
  }

  void parseResponse(String res) {
    println("< "+res);

    if (res.startsWith("echo:SD")) {
      ready = true;
    }

    if (res.startsWith("ok")) {
      ready = true;
    }
  }

  void home() {
    send("G28");
  }

  void setTemperature(int temp) {
    send("M104 S"+temp);
  }

  void getTemperature() {
    send("M105");
  }

  void disableMotors() {
    send("M84");
  }

  void getInfo() {
    send("M115");
  }

  void sendFile(String filename) {
    String[] lines = loadStrings(filename);
    for (String l : lines) {
      send(l);
    }
  }

  void setBrightness(int b) { //0..255
    send("M42 S" + b);
  }

  boolean getIdle() {
    return ready && q.size()==0;
  }

  void stop() {
    q.clear();
  }

  void beep() {
    send("M300 S1046 P133");
  }
}
