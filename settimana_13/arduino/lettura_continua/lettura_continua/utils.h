#pragma once

#include "Arduino.h"


inline uint16_t unisci_bytes(byte H, byte  L)
{
	return (H << 8) | L;
}

void SystemClock_Config(void);