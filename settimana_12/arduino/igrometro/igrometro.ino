#include <Wire.h>                       // Libreria Arduino per I2C

byte SAD = 0x44;

void setup()
{
  Serial.begin(9600);                   // - avvia seriale a 2Mbaud
  Wire.begin();                         // - avvia I2C

  // impostazione
  Wire.beginTransmission(SAD);
  Wire.write((byte) 0x27);
  Wire.write((byte) 0x37);
  Wire.endTransmission(true);
}

void loop()
{
  
  Wire.beginTransmission(SAD);
  Wire.write((byte) 0xE0);
  Wire.write((byte) 0x00);
  Wire.endTransmission(false);           // Riavviamo su SAD in lettura...
  Wire.requestFrom(SAD, (byte) 0x05);         // e richiediamo 5 bytes

  byte TH = 0, TL = 0, UH = 0, UL = 0;
  while (Wire.available()==0) delay(1);  // Attendiamo che risponda...
  TH = Wire.read();
  TL  = Wire.read();
  Wire.read();
  UH  = Wire.read();
  UL  = Wire.read();
  Wire.read();
  Wire.endTransmission(true);

  unsigned int St = (TH << 8) + TL;
  unsigned int Su = (UH << 8) + UL;
            
  float U = 100.0f * (float)Su/( (((long)1) << 16) - 1);
  float T = -45.0f + 175.0f*(float)St/( (((long)1) << 16) - 1);

  Serial.print(millis());
  Serial.print("\t");
  Serial.print(U, 4);                    // invio dati su seriale
  Serial.print("\t");
  Serial.print(T, 4
  );
  Serial.print("\n");
  delay(105);                            // attesa (msec)
}
