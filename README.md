# NetworkSwiftDemo
Intro demo to WWDC2018 new Network framework; all by swift.

How to use:
This demo contains a sender and a listener.
(Now the sender has not been implemented yet.)

You can test it with the nc tool built in the mac os.

for example:   


You use the listener in the demo, listen to port 8888;  

then go to the terminal:  

nc 127.0.0.1 8888  -- here we will get a connection  

test message1  -- typing to send messages to port 8888, will be captured by the listener  

test message2  -- typing to send messages to port 8888, will be captured by the listener  

EOF  -- ctl+c  disconnect  

