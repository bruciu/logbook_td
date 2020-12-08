#include <Wire.h>                       // Libreria Arduino per I2C
uint8_t PXL,PL,PH,TL,TH;                // - dichiarazione registri 8 bit unsigned
float PP,TT;

void setup()
{
  Serial.begin(9600);                // - avvia seriale a 2Mbaud
  Wire.begin();                         // - avvia I2C

  Wire.beginTransmission((byte) 0x5D);  // Comunicazione su SAD = 0x5D = 93
  Wire.write((byte) 0x20);              // registro SUB = 0x20 = 32
  Wire.write((byte) 0xE0);              // valore 0xE0 = b1110000
  Wire.endTransmission(true);

  Wire.beginTransmission((byte) 0x5D);
  Wire.write((byte) 0x10);
  Wire.write((byte) 0b01111010);
  Wire.endTransmission(true);
}

void loop()
{
  Wire.beginTransmission((byte) 0x5D);   // Comunicazione su SAD = 0x5D = 93
  Wire.write((byte) 0xA8);               // partiamo da SUB = 0x28 + 0x80
  Wire.endTransmission(false);           // Riavviamo su SAD in lettura...
  Wire.requestFrom((byte) 0x5D, (byte) 0x05);         // e richiediamo 5 bytes

  while (Wire.available()==0) delay(1);  // Attendiamo che risponda...
  PXL = Wire.read();                     // e leggiamo i vari bytes
  PL  = Wire.read();
  PH  = Wire.read();
  TL  = Wire.read();
  TH  = Wire.read();
  Wire.endTransmission(true);

  PP = PXL+256*(PL+256*PH);              // calcolo pressione raw
  if (PP>8388608) PP -= 16777216;        // complemento 2
  PP = PP/4096;                          // conversione digit->mbar
  TT = TL+256*TH;                        // calcolo temperatura raw
  if (TT>32768) TT -= 65536;             // complemento 2
  TT = TT/480+42.5;                      // conversione digit->C

  Serial.print(millis());
  Serial.print("\t");
  Serial.print(PP, 4);                    // invio dati su seriale
  Serial.print("\t");
  Serial.print(TT, 4
  );
  Serial.print("\n");
  delay(120);                            // attesa (msec)
}
