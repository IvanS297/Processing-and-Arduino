import processing.serial.*;
Serial serial;

void setup() {
  size(400, 200);
  
  String str[] = Serial.list();
  println(str[1]);
}

void draw() {
}
