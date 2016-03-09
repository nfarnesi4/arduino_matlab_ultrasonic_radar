/* Sweep
 by BARRAGAN <http://barraganstudio.com> 
 This example code is in the public domain.

 modified 8 Nov 2013
 by Scott Fitzgerald
 http://arduino.cc/en/Tutorial/Sweep
*/ 

#include <Servo.h> 
#include <NewPing.h>

#define TRIGGER_PIN  2  // Arduino pin tied to trigger pin on the ultrasonic sensor.
#define ECHO_PIN     3  // Arduino pin tied to echo pin on the ultrasonic sensor.
#define MAX_DISTANCE 200 // Maximum distance we want to ping for (in centimeters). Maximum sensor distance is rated at 400-500cm.
//#define PING_MEAN_SAMPLE_COUNT 10

#define SERVO_PIN 9
 
NewPing sonar(TRIGGER_PIN, ECHO_PIN, MAX_DISTANCE); 

Servo servo;  // create servo object to control a servo

bool new_pos_received = false;

int pos = 0;

String in_str = "";

void setup() 
{
  Serial.begin(9600);
  servo.attach(SERVO_PIN);
} 
 
void loop() 
{
  
  if(new_pos_received){
    //move the servo
    servo.write(pos);
    delay(50); //wait for servo to move
    
    //get the distance reading in cm
    int distance = sonar.convert_cm(sonar.ping_median());

    //print the pos, distance
    Serial.print(pos);
    Serial.print(", ");
    Serial.println(distance);

    //wait for new data
    new_pos_received = false;
  }
  
} 

//called when there is new serial data
void serialEvent()
{ 
  while (Serial.available()){
    //read in the serial data from the computer char by char
    char in = (char)Serial.read();
    
    //check for end char
    if (in != '!'){
      in_str += in; 
    }
    else{
      new_pos_received = true;
      pos = in_str.toInt();
      in_str = "";
      break;
    }
  }
}
