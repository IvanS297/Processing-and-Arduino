int speed = 115200;
String portName;
int potVal;
int fillVal;
Chart myChart;

import processing.serial.*;
Serial serial;
import controlP5.*;
ControlP5 cp5;
import meter.*;
Meter m;

void setup() {
  size(400, 400);
  cp5 = new ControlP5(this);
  cp5.addButton("open").linebreak();
  cp5.addButton("closePort").linebreak();
  cp5.addToggle("led").setMode(ControlP5.SWITCH);
  cp5.addToggle("fan").setMode(ControlP5.SWITCH);
  cp5.addToggle("bulb").setMode(ControlP5.SWITCH).linebreak();
  ;
  cp5.addScrollableList("comlist").close();
  cp5.addKnob("knob")
    .setRange(0, 180)
    .setRadius(30)
    ;
  cp5.addColorWheel("picker", 10, 250, 100);

  myChart = cp5.addChart("light")
    .setPosition(50, 50)
    .setSize(200, 100)
    .setRange(0, 1023)
    .setView(Chart.LINE)
    .addDataSet("incoming")
    .setData("incoming", new float[100])
    ;

  cp5.addSlider("temp")
    .setPosition(100, 140)
    .setSize(20, 100)
    .setRange(20, 40)
    ;

  cp5.addTextfield("input")
    .setPosition(160, 150)
    .setSize(100, 20)
    ;

  cp5.addButton("send").setPosition(160+105, 150);

  m = new Meter(this, 100, 10);
  m.setMeterWidth(200);
  m.setUp(0, 1023, 0, 100, -180, 0);
  String[] scaleLabels = {"0", "20", "40", "60", "80", "100"};
  m.setScaleLabels(scaleLabels);

  String list[] = Serial.list();
  cp5.get(ScrollableList.class, "comlist").addItems(list);
}
//.addItems(l)


void comlist(int n) {
  portName = Serial.list()[n];
}
void open() {
  serial = new Serial(this, portName, speed);
}
void closePort() {
  serial.stop();
}
void led(int val) {
  serial.write("0," + val +";");
}
void fan(int val) {
  serial.write("3," + val +";");
}
void bulb(int val) {
  serial.write("4," + val +";");
}
void send() {
  serial.write("5," + cp5.get(Textfield.class, "input").getText() + ";");
}
void picker(int col) {
  String str = "1,";
  str += int(red(col));
  str += ',';
  str += int(green(col));
  str += ',';
  str += int(blue(col));
  str += ';';
  if (serial != null) serial.write(str);
}
void knob(int val) {
  String str = "2," + val + ';';
  if (serial != null) serial.write(str);
}

int x = 200, y = 200;

void draw() {
  background(120);
  m.updateMeter(potVal);
  circle(x, y, 30);

  fill(fillVal);
  if (serial != null) {
    if (serial.available() > 0) {
      String str = serial.readStringUntil('\n');
      str = str.trim();
      String data[] = str.split(",");
      switch (int(data[0])) {
      case 0:
        potVal = int(int(data[1]));
        myChart.push("incoming", int(data[2]));
        cp5.get(Slider.class, "temp").setValue(float(data[3]));
        break;
      case 1:
        fillVal = int(data[1]) * 255;
        break;
      case 2:
        x += map(int(data[1]), 0, 1023, -5, 5);
        y += map(int(data[2]), 0, 1023, -5, 5);
        break;
      }
    }
  }
}
