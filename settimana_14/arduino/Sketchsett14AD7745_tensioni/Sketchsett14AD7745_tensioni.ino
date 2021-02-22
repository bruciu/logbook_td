#include <Wire.h>
#include "funzioni_i2c.h"

#define STATUS 0x00
#define CAPSETUP 0x07
#define VTSETUP 0x08
#define EXCSETUP 0x09
#define CONFIG 0x0A


void setup() {
  // put your setup code here, to run once:
  Serial.begin(57600);

  Wire.begin();
  setRegister(VTSETUP, 0b11100000);
  setRegister(CONFIG, 0b00000001);
}

void loop() {
  // put your main code here, to run repeatedly:
  
  byte result = 0;
  do {
    result = readByte(STATUS);
  }while(result & 0b10);
  
  byte results[3] = {};
  readBytes(0x04, results, 3);

  float r = (int)results[0] * 256*256 + (int)results[1] *256 + (int) results[2];
  r -= 0x800000;
  r /= 0x800000;
  r *= 1.17;

  Serial.println(r, 6);
  
  Serial.print(results[0], HEX);
  Serial.print(results[1], HEX);
  Serial.println(results[2], HEX);
  
  //delay(100);//inutile, avendo fatto sopra un controllo... limiterebbe la velocità.
  
}
