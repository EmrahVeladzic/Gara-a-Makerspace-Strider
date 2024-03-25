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


#define RUNTIME 100

void setup() {
  // put your setup code here, to run once:

  pinMode(L_Enable,OUTPUT);
  pinMode(R_Enable,OUTPUT);
  pinMode(L_FWD,OUTPUT);
  pinMode(L_REV,OUTPUT);
  pinMode(R_FWD,OUTPUT);
  pinMode(R_REV,OUTPUT);

 Serial.begin(115200);
}

void loop() {
  // put your main code here, to run repeatedly:
  if(Serial.available()){
  
 enable();


  char cmd = Serial.read();

 switch(cmd){
 case 'W':forward();break;
 case 'A':left();break;
  case 'S':reverse();break;
   case 'D':right();break;

 default:break;
 }


disable();

  }


}

void left(){

digitalWrite(R_FWD,HIGH);
digitalWrite(L_REV,HIGH);
delay(RUNTIME);
digitalWrite(R_FWD,LOW);
digitalWrite(L_REV,LOW);

}

void right(){

digitalWrite(L_FWD,HIGH);
digitalWrite(R_REV,HIGH);
delay(RUNTIME);
digitalWrite(L_FWD,LOW);
digitalWrite(R_REV,LOW);

}

void forward(){

digitalWrite(L_FWD,HIGH);
digitalWrite(R_FWD,HIGH);
delay(RUNTIME);
digitalWrite(L_FWD,LOW);
digitalWrite(R_FWD,LOW);

}

void reverse(){

digitalWrite(L_REV,HIGH);
digitalWrite(R_REV,HIGH);
delay(RUNTIME);
digitalWrite(L_REV,LOW);
digitalWrite(R_REV,LOW);

}

void enable(){
digitalWrite(L_Enable,HIGH);
digitalWrite(R_Enable,HIGH);
}
void disable(){
digitalWrite(L_Enable,LOW);
digitalWrite(R_Enable,LOW);
}
