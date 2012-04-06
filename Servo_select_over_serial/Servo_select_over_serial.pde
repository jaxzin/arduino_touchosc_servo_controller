// Sweep
// by BARRAGAN <http://barraganstudio.com> 
// This example code is in the public domain.

// Range appears to be 0-171, and 600-2300 micros, 1350 midpoint


#include <Servo.h> 
 
#define LED_PIN 13
#define SERVO_A_PIN 9
#define SERVO_B_PIN 10
 
#define STATE_WAITING 0 // waiting for input
#define STATE_READ_A  1 // currently reading the value for servo a
#define STATE_READ_B  2 // currently reading the value for servo b
#define STATE_UPDATE_A  3  // done reading value for servo a, ready to update
#define STATE_UPDATE_B  4  // done reading value for servo b, ready to update

Servo myservoA;  // create servo object to control a servo 
                // a maximum of eight servo objects can be created 
Servo myservoB; 
 
int state = STATE_WAITING;
int posA = 0;    // variable to store the servo position 
int posB = 0;    // variable to store the servo position 
 
void setup() 
{ 
  myservoA.attach(SERVO_A_PIN);  // attaches the servo on pin 9 to the servo object 
  myservoB.attach(SERVO_B_PIN);  // attaches the servo on pin 10 to the servo object 
  Serial.begin(9600);
  digitalWrite(LED_PIN, LOW);
  //Serial.println("Enter the servo position in degrees (0 - 180), followed by a period.");
} 
 
 
void loop() 
{ 
  while(Serial.available() > 0) {
    byte temp = Serial.read();
    // 'a' signifies the start of data for servo A
    if(temp == 'a') {
      state = STATE_READ_A;
    // 'b' signifies the start of data for servo A
    } else if(temp == 'b') {
      state = STATE_READ_B;
    } else if(temp == '.') {
      // transistion state to update whichever value we've been reading
      state = STATE_READ_A ? STATE_UPDATE_A : STATE_UPDATE_B;
      break;
    } else if(state == STATE_READ_A) {
      posA *= 10; // shift the currently stored position
      posA += (temp - '0'); // Add the new digit;
    } else if(state == STATE_READ_B) {
      posB *= 10; // shift the currently stored position
      posB += (temp - '0'); // Add the new digit;
    } else {
      // TODO: Warn about reading data outside of a/b context
    }
  }

  if(state == STATE_UPDATE_A && posA >= 0 && posA <= 180) {
    updateServo(myservoA, posA);
    posA = 0;
    state = STATE_WAITING;
    
    // Blink LED as a sign of movement, twice over a quarter-second
    //blinkLed(LED_PIN, 2, 250);
  }
  else if(state == STATE_UPDATE_B && posB >= 0 && posB <= 180) {
    updateServo(myservoB, posB);
    posB = 0;
    state = STATE_WAITING;
  }
  // TODO: Warn about invalid position data


}

void updateServo(Servo servo, int pos) {
    int temp = map(pos, 0, 180, 550, 2300); // Map degrees (0-180) to Futaba servo microseconds...
    servo.writeMicroseconds(temp);
}
