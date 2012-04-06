// Sweep
// by BARRAGAN <http://barraganstudio.com> 
// This example code is in the public domain.

// Range appears to be 0-171, and 600-2300 micros, 1350 midpoint


#include <Servo.h> 
 
#define LED_PIN 13
#define SERVO_A_PIN 9
#define SERVO_B_PIN 10
 
Servo myservoA;  // create servo object to control a servo 
                // a maximum of eight servo objects can be created 
Servo myservoB; 
 
int pos = 0;    // variable to store the servo position 
 
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
  boolean update = false;
  while(Serial.available() > 0) {
    byte temp = Serial.read();
    if(temp == '.') {
      update = true;
      break;
    } else {
      pos *= 10; // shift the currently stored position
      pos += (temp - '0'); // Add the new digit;
    }
  }

  if(update && pos >= 0 && pos <= 180) {
    int temp = map(pos, 0, 180, 550, 2300); // Map degrees (0-180) to Futaba servo microseconds...
    myservoA.writeMicroseconds(temp);
    myservoB.writeMicroseconds(temp);
    //Serial.print("Moving to position ");
    //Serial.println(pos, DEC);
    pos = 0;
    
    // Blink LED as a sign of movement, twice over a quarter-second
    //blinkLed(LED_PIN, 2, 250);
  }
  // Warn on invalid data
  else if(update) {
    //Serial.print("Invalid position [");
    //Serial.print(pos, DEC);
    //Serial.println("]. Please enter a position between 0 and 180 degrees");
    pos = 0;
  }
}

void blinkLed(int pin, int times, int duration) {
  // The length of being on or off (total duration devided by the number of blinks + spaces in between)
  int pulseDuration = duration / ((times * 2) - 1);
  
  for(int i = 0; i < times; i++) {
    digitalWrite(pin, HIGH);
    delay(pulseDuration);
    digitalWrite(pin, LOW);
    // if its not the last blink...
    if(i != times - 1) {
      delay(pulseDuration);
    }
  }
  
}

