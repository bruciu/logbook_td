/*
  Blink
  Turns on an LED on for one second, then off for one second, repeatedly.

  Most Arduinos have an on-board LED you can control. On the Uno and
  Leonardo, it is attached to digital pin 13. If you're unsure what
  pin the on-board LED is connected to on your Arduino model, check
  the documentation at http://arduino.cc

  This example code is in the public domain.

  modified 8 May 2014
  by Scott Fitzgerald
 */

#include "registri.hpp"
#include "funzioni_i2c.h"
#include "utils.h"

unsigned todo_count;
auto t = micros();
unsigned count = 0;

void setup() {

	SystemClock_Config();

	Serial.begin(2000000);
	Wire.begin();
	Wire.setClock(400000);

	// initialize digital pin 13 as an output.
	pinMode(LED_GREEN, OUTPUT);
	
	
	// ================================
	//       IMPOSTAZIONI SENSORE
	// ================================
	
	// RESET
	setRegister(PWR_MGMT_1, 0b10000000);
	delay(1000);
	
	// disabilita lo stand by (riattiva il sensore)
	setRegister(PWR_MGMT_1, 0b00000000);
	
	// imposta il div
	// TODO
	setRegister(SMPRT_DIV, 0x07);
	
	// config, no DLFP
	setRegister(CONFIG, 0x00);
	
	// configurazione giroscopio (fondi scala)
	setRegister(GYRO_CONFIG, 0b00000000);
	
	// configurazione accelerometri (fondi scala)
	setRegister(ACCEL_CONFIG, 0b00000000);
	
	// imposta per mettere sulla FIFO giroscopio e accelerometro
	setRegister(FIFO_EN, 0b01111000);
	
	// attiva la FIFO
	FIFO_enable();
	FIFO_clear();

	todo_count = 0;
	t = micros();
	count = 0;
}

byte data[12];

// abilita per debug FIFO
//#define PRINT_INFO

// abilita per inserire una pause di debug
//#define DEBUG_PAUSE


void loop() {

	if (todo_count == 0)
	{
		uint16_t s = 0;

		// aspetta che ci siano dati
		while ((s = FIFO_size()) < 12);

		todo_count = s / 12;

#ifdef DEBUG_PAUSE
		delay(10);
#endif // DEBUG_PAUSE

	}
	todo_count--;

	//Serial.println(micros() - t);

	readBytes(FIFO_R_W, data, 12);

	//Serial.println(micros() - t);

	int i = 0;
	Serial.print(unisci_bytes(data[i++], data[i++]), HEX);
	Serial.print("\t");
	Serial.print(unisci_bytes(data[i++], data[i++]), HEX);
	Serial.print("\t");
	Serial.print(unisci_bytes(data[i++], data[i++]), HEX);
	Serial.print("\t");
	Serial.print(unisci_bytes(data[i++], data[i++]), HEX);
	Serial.print("\t");
	Serial.print(unisci_bytes(data[i++], data[i++]), HEX);
	Serial.print("\t");
	Serial.print(unisci_bytes(data[i++], data[i++]), HEX);

#ifdef PRINT_INFO
	Serial.print("\t");
	Serial.print(todo_count);
	Serial.print("\t");

	auto t2 = micros();
	Serial.print(t2 - t);
	t = t2;
#endif // PRINT_INFO

	Serial.println();
}
