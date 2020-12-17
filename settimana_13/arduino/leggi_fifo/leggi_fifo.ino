#include <Wire.h> 

byte SAD = 0x68;

// ================================
//             REGISTRI
// ================================

#define PWR_MGMT_1    0x6B
#define SMPRT_DIV     0x19
#define GYRO_CONFIG   0x1B
#define ACCEL_CONFIG  0x1C
#define CONFIG        0x1A
#define FIFO_EN       0x23
#define USER_CTRL     0x6A

// ================================
//             FUNZIONI
// ================================
void setRegister(byte SUB, byte value, bool end = true);
void requestBytes(byte SUB, byte nVals = 1);
inline byte readByte(void)
{
  return Wire.read();
}
void stopRead(void);

void setup() {

  // seriale alla velocita' massima
  Serial.begin(2000000);
}

void loop() {

}


void setRegister(byte SUB, byte value, bool end)
{
  Wire.beginTransmission(SAD);
  Wire.write(SUB);
  Wire.write(value);
  Wire.endTransmission(end);
}

void requestBytes(byte SUB, byte nVals)
{
  Wire.beginTransmission(SAD);
  Wire.write(SUB);
  Wire.endTransmission(false);
  Wire.requestFrom(SAD, nVals);
}
void stopRead(void)
{
  Wire.endTransmission(true);
}



/*

Cose da ricordarsi:

- burst read
- wire speed?
    https://www.arduino.cc/en/Reference/WireSetClock
    file:///C:/Users/Luca/AppData/Local/Temp/stm32l4r5zi.pdf pag 57
- MCU clock speed?
    https://www.st.com/en/microcontrollers-microprocessors/stm32l4r5zi.html#documentation
    vedi codice prof
 */
