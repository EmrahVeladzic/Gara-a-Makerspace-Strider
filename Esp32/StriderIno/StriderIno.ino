#include "BluetoothSerial.h"
#include <ESP32Servo.h>

#define pinL 17
#define pinR 18

#define FWD 'W'
#define L 'A'
#define REV 'S'
#define R 'D'

#define LL 'Y'
#define RL 'E'

#define LR 'Q'
#define RR 'C'

#define STOP 'X'
volatile char cmd = STOP;

#define RUNTIME 10

BluetoothSerial BT_S;
Servo sL;
Servo sR;

void setup() {
  // put your setup code here, to run once:

  pinMode(pinL,OUTPUT);
  pinMode(pinR,OUTPUT);

  sL.attach(pinL);
  sR.attach(pinR);

 Serial.begin(115200);
  BT_S.begin("Strider");
}

void loop() {
  // put your main code here, to run repeatedly:

  if(BT_S.available()){
    
   cmd = BT_S.read();
    

  }


  switch(cmd){
      case FWD:forward();break;
      case L:full_left();break;
      case REV:reverse();break;
      case R:full_right();break;

      case LL:L_only_left();break;
      case RL:R_only_left();break;
      case LR:L_only_right();break;
      case RR:R_only_right();break;
      case STOP: disable();break;
     

      default:break;
  }

 delay(RUNTIME);

}

void full_left(){

sL.write(0);
sR.write(0);


}

void full_right(){

sL.write(180);
sR.write(180);

}

void forward(){

sL.write(180);
sR.write(0);


}

void reverse(){

sL.write(0);
sR.write(180);


}

void L_only_left(){

sL.write(0);
sR.write(90);

}
void R_only_left(){
sL.write(90);
sR.write(180);
  
}

void L_only_right(){
sL.write(180);
sR.write(90);
  
}

void R_only_right(){
sL.write(90);
sR.write(0);
  
}

void disable(){

sL.write(90);
sR.write(90);

}
