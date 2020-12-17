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


// ================================
//              FIFO
// ================================

void FIFO_enable(void);

void FIFO_clear(void);

uint16_t FIFO_size(void);

