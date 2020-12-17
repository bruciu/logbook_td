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

void setup() {


	// initialize digital pin 13 as an output.
	pinMode(LED_GREEN, OUTPUT);


	// ================================
	//       IMPOSTAZIONI SENSORE
	// ================================

	// RESET
	setRegister(PWR_MGMT_1, 0b10000000);

	// disabilita lo stand by (riattiva il sensore)
	setRegister(PWR_MGMT_1, 0b00000000);

	// imposta il div
	// TODO
	setRegister(SMPRT_DIV, 0x4F);

	// config, no DLFP
	setRegister(CONFIG, 0x00);

	// configurazione giroscopio (fondi scala)
	setRegister(GYRO_CONFIG, 0b00011000);

	// configurazione accelerometri (fondi scala)
	setRegister(ACCEL_CONFIG, 0b00010000);

	// imposta per mettere sulla FIFO giroscopio e accelerometro
	setRegister(FIFO_EN, 0b01111000);

	// attiva la FIFO
	FIFO_enable();
	FIFO_clear();
}


void loop() {
	
	auto n = FIFO_size();

	Serial.println(n);

	if (n > 1000)
		FIFO_clear();
}


