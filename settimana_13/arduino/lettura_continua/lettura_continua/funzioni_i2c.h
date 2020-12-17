#pragma once

#include <Arduino.h>

#include <Wire.h>

extern const byte SAD;

// imposta il valore di un registro
void setRegister(byte SUB, byte value);

// leggi un singolo byte da uno specifico sub
byte readByte(byte SUB);

// leggi una sequenza di bytes
void readBytes(byte SUB, byte* buff, byte count);

