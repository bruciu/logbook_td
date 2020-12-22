#pragma once




// ================================
//             REGISTRI
// ================================

// struttura: |7|6|5|4|3|2|1|0|
//   7: DEVICE_RESET mettere a 1 per resettare tutto (nota: va in stand by)
//   6: SLEEP        impostare a 0
//   5: CYCLE        impostare a 0
//   4: N/A          impostare a 0
//   3: TEMP_DIS     disabilita sensore (impostare a 0)
//   2: CLKSEL[2]    impostare a 0
//   1: CLKSEL[1]    impostare a 0
//   0: CLKSEL[0]    impostare a 0
#define PWR_MGMT_1    0x6B


// divisione sample rate
// Sample Rate = Gyroscope Output Rate / (1 + SMPLRT_DIV)
// where Gyroscope Output Rate = 8kHz when the DLPF is disabled (DLPF_CFG= 0 or 7), and 1kHz when
// the DLPF is enabled (see Register CONFIG)
#define SMPRT_DIV     0x19

// struttura: |7|6|5|4|3|2|1|0|
//   7: N/A             impostare a 0
//   6: N/A             impostare a 0
//   5: EXT_SYNC_SET[2] impostare a o
//   4: EXT_SYNC_SET[1] impostare a o
//   3: EXT_SYNC_SET[0] impostare a o
//   2: DLPF_CFG[2]     vedi pag 13
//   1: DLPF_CFG[1]     vedi pag 13
//   0: DLPF_CFG[0]     vedi pag 13
#define CONFIG        0x1A

// struttura: |7|6|5|4|3|2|1|0|
//   7: XG_ST    impostare a 0
//   6: YG_ST    impostare a 0
//   5: ZG_ST    impostare a 0
//   4: 
//   3: 
//   2: 
//   1: 
//   0: 
#define GYRO_CONFIG   0x1B
#define ACCEL_CONFIG  0x1C

// imostazioni della FIFO
#define FIFO_EN       0x23

// dentro c'è abilita/disabilita FIFO
#define USER_CTRL     0x6A

#define FIFO_COUNT_H 0x72
#define FIFO_COUNT_L 0x73
#define FIFO_R_W     0x74

