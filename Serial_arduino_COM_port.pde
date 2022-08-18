int speed = 9600;
String portName;

import processing.serial.*;
Serial serial;
import controlP5.*;
ControlP5 cp5;

void setup() {
  size(400, 200);
  cp5 = new ControlP5(this);
  
  cp5.addButton("refresh").linebreak();
  cp5.addButton("open").linebreak();
  cp5.addButton("closePort").linebreak();
  cp5.addButton("ledOn").linebreak();
  cp5.addButton("ledOff").linebreak();
  cp5.addScrollableList("comlist").close();
   
  serial = new Serial(this, "COM38", speed);
}
//.addItems(l)

void refresh() {
  String list[] = Serial.list();
  cp5.get(ScrollableList.class, "comlist").addItems(list);
}
void comlist(int n) {
  portName = Serial.list()[n];
}
void open() {
  serial = new Serial(this, portName, speed);
}
void closePort() {
  serial.stop();
}
void ledOn() {
  serial.write('n');
}
void ledOff() {
  serial.write('f');
}

void draw() {
  background(120);
}
