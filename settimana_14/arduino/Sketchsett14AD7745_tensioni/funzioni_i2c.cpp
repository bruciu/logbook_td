// 
// 
// 

#include "funzioni_i2c.h"


const byte SAD = 0x48;

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
	while (Wire.available() == 0);
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
