// 
// 
// 

#include "registri.hpp"
#include "funzioni_i2c.h"

#include "utils.h"


const byte SAD = 0x68;

////////////////////////////////////////////////////////////////
void setRegister(byte SUB, byte value)
{
	Wire.beginTransmission(SAD);
	Wire.write(SUB);
	Wire.write(value);
	Wire.endTransmission(true);
}


////////////////////////////////////////////////////////////////
// richiede nVals valori da un registro SUB
// esempio:
//   requestBytes()
//   readByte()
//   requstopReadestBytes()
inline void requestBytes(byte SUB, byte nVals)
{
	Wire.beginTransmission(SAD);
	Wire.write(SUB);
	Wire.endTransmission(false);
	Wire.requestFrom(SAD, nVals);
	while (Wire.available() < nVals) delay(1);
}

////////////////////////////////////////////////////////////////
// leggi singolo byte
inline byte getByte(void)
{
	return Wire.read();
}

////////////////////////////////////////////////////////////////
// ferma la lettura dopo che sono stati richiesti dei bytes
inline void stopRead(void)
{
	Wire.endTransmission(true);
}

////////////////////////////////////////////////////////////////
byte readByte(byte SUB)
{
	requestBytes(SUB, 1);

	byte result = getByte();

	stopRead();

	return result;
}

////////////////////////////////////////////////////////////////
void readBytes(byte SUB, byte* buff, byte count)
{
	requestBytes(SUB, count);

	for (int i = 0; i < count; i++)
		buff[i] = getByte();

	stopRead();
}

////////////////////////////////////////////////////////////////
void FIFO_enable(void)
{
	setRegister(USER_CTRL, 0b01000000);
}

////////////////////////////////////////////////////////////////
void FIFO_clear(void)
{
	setRegister(USER_CTRL, 0b01000100);
}

////////////////////////////////////////////////////////////////
uint16_t FIFO_size(void)
{
	byte bytes[2];

	//readBytes(FIFO_COUNT_H, bytes, 2);

	bytes[1] = readByte(FIFO_COUNT_H);
	bytes[2] = readByte(FIFO_COUNT_L);

	return unisci_bytes(bytes[1], bytes[2]);
}




