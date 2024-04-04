#include "BluetoothSerial.h"



#define L_Enable 22
#define R_Enable 23

#define L_FWD 19
#define R_FWD 17

#define L_REV 18
#define R_REV 16


#define FWD 'W'
#define L 'A'
#define REV 'S'
#define R 'D'


#define LL 'Y'
#define RL 'E'


#define LR 'Q'
#define RR 'C'


#define RUNTIME 10

BluetoothSerial BT_S;

void setup() {
  // put your setup code here, to run once:

  pinMode(L_Enable,OUTPUT);
  pinMode(R_Enable,OUTPUT);
  pinMode(L_FWD,OUTPUT);
  pinMode(L_REV,OUTPUT);
  pinMode(R_FWD,OUTPUT);
  pinMode(R_REV,OUTPUT);

 Serial.begin(115200);
  BT_S.begin("Strider");
}

void loop() {
  // put your main code here, to run repeatedly:
  if(BT_S.available()){
  
    enable();


    char cmd = BT_S.read();

    switch(cmd){
      case FWD:forward();break;
      case L:full_left();break;
      case REV:reverse();break;
      case R:full_right();break;

      case LL:L_only_left();break;
      case RL:R_only_left();break;
      case LR:L_only_right();break;
      case RR:R_only_right();break;

      default:break;

    }

    

    delay(RUNTIME);


    disable();

  }


}

void full_left(){

digitalWrite(R_FWD,HIGH);
digitalWrite(L_REV,HIGH);


}

void full_right(){

digitalWrite(L_FWD,HIGH);
digitalWrite(R_REV,HIGH);


}

void forward(){

digitalWrite(L_FWD,HIGH);
digitalWrite(R_FWD,HIGH);

}

void reverse(){

digitalWrite(L_REV,HIGH);
digitalWrite(R_REV,HIGH);


}

void L_only_left(){
digitalWrite(L_REV,HIGH);

}
void R_only_left(){
digitalWrite(R_FWD,HIGH);
  
}

void L_only_right(){
digitalWrite(L_FWD,HIGH);
  
}

void R_only_right(){
digitalWrite(R_REV,HIGH);
  
}

void enable(){
digitalWrite(L_Enable,HIGH);
digitalWrite(R_Enable,HIGH);
}
void disable(){
digitalWrite(L_Enable,LOW);
digitalWrite(R_Enable,LOW);

digitalWrite(L_FWD,LOW);
digitalWrite(R_FWD,LOW);

digitalWrite(L_REV,LOW);
digitalWrite(R_REV,LOW);
}
