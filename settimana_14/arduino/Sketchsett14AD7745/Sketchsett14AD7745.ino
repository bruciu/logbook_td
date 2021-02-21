#include <Wire.h>
#include "funzioni_i2c.h"

#define STATUS 0x00
#define CAPSETUP 0x07
#define EXCSETUP 0x09
#define CONFIG 0x0A


void setup() {
  // put your setup code here, to run once:
  Serial.begin(57600);

  Wire.begin();
  setRegister(CAPSETUP, 0b10000001);
  setRegister(EXCSETUP, 0b00100000);
}

void loop() {
  // put your main code here, to run repeatedly:
  setRegister(CONFIG, 0b11111010);
  delay(200);
  
  byte result = 0;
  do {
    result = readByte(STATUS);
    if(result & 0b1000){
      Serial.println("Errore");
      break;
      }
  }while(result & 0b1);
  
  byte results[3] = {};
  readBytes(0x01, results, 3);

  float r = (int)results[0] * 256*256 + (int)results[1] *256 + (int) results[2];
  r -= 0x800000;
  r /= 0x800000 >> 12;
  //r *= 4096;

  Serial.println(r, 4);
  Serial.print(results[0], HEX);
  Serial.print(results[1], HEX);
  Serial.println(results[2], HEX);
  
}
