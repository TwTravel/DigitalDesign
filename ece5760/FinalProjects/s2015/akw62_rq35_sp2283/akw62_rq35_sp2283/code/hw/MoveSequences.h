 
parameter moveNone              = 0;
parameter moveLeftClock         = 1;
parameter moveLeftCounterClock  = 2;
parameter moveRightClock        = 3;
parameter moveRightCounterClock = 4;
parameter moveFrontClock        = 5;
parameter moveFrontCounterClock = 6;
parameter moveForward           = 7;
parameter moveBackward          = 8;
parameter resetYourself         = 9;

////---------------------------------------------////
//--------Nothing----------------------------------//
////---------------------------------------------////

assign numMoves[moveNone] = 5'd1;

//Tick 0
assign moves[moveNone][0][0] = zero;
assign moves[moveNone][1][0] = zero; 
assign moves[moveNone][2][0] = zero;
assign moves[moveNone][3][0] = cClosed;
assign moves[moveNone][4][0] = cClosed;
assign moves[moveNone][5][0] = cClosed;

////---------------------------------------------////
//--------Left Clockwise---------------------------//
////---------------------------------------------////

assign numMoves[moveLeftClock] = 5'd4;

//Tick 0
assign moves[moveLeftClock][0][0] = posNinety;
assign moves[moveLeftClock][1][0] = zero; 
assign moves[moveLeftClock][2][0] = zero;
assign moves[moveLeftClock][3][0] = cClosed;
assign moves[moveLeftClock][4][0] = cClosed;
assign moves[moveLeftClock][5][0] = cClosed;

//Tick 1
assign moves[moveLeftClock][0][1] = posNinety;
assign moves[moveLeftClock][1][1] = zero; 
assign moves[moveLeftClock][2][1] = zero;
assign moves[moveLeftClock][3][1] = cOpen;
assign moves[moveLeftClock][4][1] = cClosed;
assign moves[moveLeftClock][5][1] = cClosed;

//Tick 2
assign moves[moveLeftClock][0][2] = zero;
assign moves[moveLeftClock][1][2] = zero; 
assign moves[moveLeftClock][2][2] = zero;
assign moves[moveLeftClock][3][2] = cOpen;
assign moves[moveLeftClock][4][2] = cClosed;
assign moves[moveLeftClock][5][2] = cClosed;

//Tick 3
assign moves[moveLeftClock][0][3] = zero;
assign moves[moveLeftClock][1][3] = zero; 
assign moves[moveLeftClock][2][3] = zero;
assign moves[moveLeftClock][3][3] = cClosed;
assign moves[moveLeftClock][4][3] = cClosed;
assign moves[moveLeftClock][5][3] = cClosed;

////---------------------------------------------////
//--------Left CounterClockwise--------------------//
////---------------------------------------------////

assign numMoves[moveLeftCounterClock] = 5'd4;

//Tick 0
assign moves[moveLeftCounterClock][0][0] = negNinety;
assign moves[moveLeftCounterClock][1][0] = zero; 
assign moves[moveLeftCounterClock][2][0] = zero;
assign moves[moveLeftCounterClock][3][0] = cClosed;
assign moves[moveLeftCounterClock][4][0] = cClosed;
assign moves[moveLeftCounterClock][5][0] = cClosed;

//Tick 1
assign moves[moveLeftCounterClock][0][1] = negNinety;
assign moves[moveLeftCounterClock][1][1] = zero; 
assign moves[moveLeftCounterClock][2][1] = zero;
assign moves[moveLeftCounterClock][3][1] = cOpen;
assign moves[moveLeftCounterClock][4][1] = cClosed;
assign moves[moveLeftCounterClock][5][1] = cClosed;

//Tick 2
assign moves[moveLeftCounterClock][0][2] = zero;
assign moves[moveLeftCounterClock][1][2] = zero; 
assign moves[moveLeftCounterClock][2][2] = zero;
assign moves[moveLeftCounterClock][3][2] = cOpen;
assign moves[moveLeftCounterClock][4][2] = cClosed;
assign moves[moveLeftCounterClock][5][2] = cClosed;

//Tick 3
assign moves[moveLeftCounterClock][0][3] = zero;
assign moves[moveLeftCounterClock][1][3] = zero; 
assign moves[moveLeftCounterClock][2][3] = zero;
assign moves[moveLeftCounterClock][3][3] = cClosed;
assign moves[moveLeftCounterClock][4][3] = cClosed;
assign moves[moveLeftCounterClock][5][3] = cClosed;

////---------------------------------------------////
//--------Right Clockwise---------------------------//
////---------------------------------------------////

assign numMoves[moveRightClock] = 5'd4;

//Tick 0
assign moves[moveRightClock][0][0] = zero;
assign moves[moveRightClock][1][0] = zero; 
assign moves[moveRightClock][2][0] = posNinety;
assign moves[moveRightClock][3][0] = cClosed;
assign moves[moveRightClock][4][0] = cClosed;
assign moves[moveRightClock][5][0] = cClosed;

//Tick 1
assign moves[moveRightClock][0][1] = zero;
assign moves[moveRightClock][1][1] = zero; 
assign moves[moveRightClock][2][1] = posNinety;
assign moves[moveRightClock][3][1] = cClosed;
assign moves[moveRightClock][4][1] = cClosed;
assign moves[moveRightClock][5][1] = cOpen;

//Tick 2
assign moves[moveRightClock][0][2] = zero;
assign moves[moveRightClock][1][2] = zero; 
assign moves[moveRightClock][2][2] = zero;
assign moves[moveRightClock][3][2] = cClosed;
assign moves[moveRightClock][4][2] = cClosed;
assign moves[moveRightClock][5][2] = cOpen;

//Tick 3
assign moves[moveRightClock][0][3] = zero;
assign moves[moveRightClock][1][3] = zero; 
assign moves[moveRightClock][2][3] = zero;
assign moves[moveRightClock][3][3] = cClosed;
assign moves[moveRightClock][4][3] = cClosed;
assign moves[moveRightClock][5][3] = cClosed;

////---------------------------------------------////
//--------Right CounterClockwise-------------------//
////---------------------------------------------////

assign numMoves[moveRightCounterClock] = 5'd4;

//Tick 0
assign moves[moveRightCounterClock][0][0] = zero;
assign moves[moveRightCounterClock][1][0] = zero; 
assign moves[moveRightCounterClock][2][0] = negNinety;
assign moves[moveRightCounterClock][3][0] = cClosed;
assign moves[moveRightCounterClock][4][0] = cClosed;
assign moves[moveRightCounterClock][5][0] = cClosed;

//Tick 1
assign moves[moveRightCounterClock][0][1] = zero;
assign moves[moveRightCounterClock][1][1] = zero; 
assign moves[moveRightCounterClock][2][1] = negNinety;
assign moves[moveRightCounterClock][3][1] = cClosed;
assign moves[moveRightCounterClock][4][1] = cClosed;
assign moves[moveRightCounterClock][5][1] = cOpen;

//Tick 2
assign moves[moveRightCounterClock][0][2] = zero;
assign moves[moveRightCounterClock][1][2] = zero; 
assign moves[moveRightCounterClock][2][2] = zero;
assign moves[moveRightCounterClock][3][2] = cClosed;
assign moves[moveRightCounterClock][4][2] = cClosed;
assign moves[moveRightCounterClock][5][2] = cOpen;

//Tick 3
assign moves[moveRightCounterClock][0][3] = zero;
assign moves[moveRightCounterClock][1][3] = zero; 
assign moves[moveRightCounterClock][2][3] = zero;
assign moves[moveRightCounterClock][3][3] = cClosed;
assign moves[moveRightCounterClock][4][3] = cClosed;
assign moves[moveRightCounterClock][5][3] = cClosed;

////---------------------------------------------////
//--------Front Clockwise--------------------------//
////---------------------------------------------////

assign numMoves[moveFrontClock] = 5'd4;

//Tick 0
assign moves[moveFrontClock][0][0] = zero;
assign moves[moveFrontClock][1][0] = posNinety; 
assign moves[moveFrontClock][2][0] = zero;
assign moves[moveFrontClock][3][0] = cClosed;
assign moves[moveFrontClock][4][0] = cClosed;
assign moves[moveFrontClock][5][0] = cClosed;

//Tick 1
assign moves[moveFrontClock][0][1] = zero;
assign moves[moveFrontClock][1][1] = posNinety; 
assign moves[moveFrontClock][2][1] = zero;
assign moves[moveFrontClock][3][1] = cClosed;
assign moves[moveFrontClock][4][1] = cOpen;
assign moves[moveFrontClock][5][1] = cClosed;

//Tick 2
assign moves[moveFrontClock][0][2] = zero;
assign moves[moveFrontClock][1][2] = zero; 
assign moves[moveFrontClock][2][2] = zero;
assign moves[moveFrontClock][3][2] = cClosed;
assign moves[moveFrontClock][4][2] = cOpen;
assign moves[moveFrontClock][5][2] = cClosed;

//Tick 3
assign moves[moveFrontClock][0][3] = zero;
assign moves[moveFrontClock][1][3] = zero; 
assign moves[moveFrontClock][2][3] = zero;
assign moves[moveFrontClock][3][3] = cClosed;
assign moves[moveFrontClock][4][3] = cClosed;
assign moves[moveFrontClock][5][3] = cClosed;

////---------------------------------------------////
//--------Front CounterClockwise-------------------//
////---------------------------------------------////

assign numMoves[moveFrontCounterClock] = 5'd4;

//Tick 0
assign moves[moveFrontCounterClock][0][0] = zero;
assign moves[moveFrontCounterClock][1][0] = negNinety; 
assign moves[moveFrontCounterClock][2][0] = zero;
assign moves[moveFrontCounterClock][3][0] = cClosed;
assign moves[moveFrontCounterClock][4][0] = cClosed;
assign moves[moveFrontCounterClock][5][0] = cClosed;

//Tick 1
assign moves[moveFrontCounterClock][0][1] = zero;
assign moves[moveFrontCounterClock][1][1] = negNinety; 
assign moves[moveFrontCounterClock][2][1] = zero;
assign moves[moveFrontCounterClock][3][1] = cClosed;
assign moves[moveFrontCounterClock][4][1] = cOpen;
assign moves[moveFrontCounterClock][5][1] = cClosed;

//Tick 2
assign moves[moveFrontCounterClock][0][2] = zero;
assign moves[moveFrontCounterClock][1][2] = zero; 
assign moves[moveFrontCounterClock][2][2] = zero;
assign moves[moveFrontCounterClock][3][2] = cClosed;
assign moves[moveFrontCounterClock][4][2] = cOpen;
assign moves[moveFrontCounterClock][5][2] = cClosed;

//Tick 3
assign moves[moveFrontCounterClock][0][3] = zero;
assign moves[moveFrontCounterClock][1][3] = zero; 
assign moves[moveFrontCounterClock][2][3] = zero;
assign moves[moveFrontCounterClock][3][3] = cClosed;
assign moves[moveFrontCounterClock][4][3] = cClosed;
assign moves[moveFrontCounterClock][5][3] = cClosed;

////---------------------------------------------////
//--------Rotate Toward You------------------------//
////---------------------------------------------////

assign numMoves[moveForward] = 5'd9;

//Tick 0
assign moves[moveForward][0][0] = zero;
assign moves[moveForward][1][0] = zero; 
assign moves[moveForward][2][0] = zero;
assign moves[moveForward][3][0] = cOpen;
assign moves[moveForward][4][0] = cClosed;
assign moves[moveForward][5][0] = cClosed;

//Tick 1
assign moves[moveForward][0][1] = negNinety;
assign moves[moveForward][1][1] = zero; 
assign moves[moveForward][2][1] = zero;
assign moves[moveForward][3][1] = cOpen;
assign moves[moveForward][4][1] = cClosed;
assign moves[moveForward][5][1] = cClosed;

//Tick 2
assign moves[moveForward][0][2] = negNinety;
assign moves[moveForward][1][2] = zero; 
assign moves[moveForward][2][2] = zero;
assign moves[moveForward][3][2] = cClosed;
assign moves[moveForward][4][2] = cClosed;
assign moves[moveForward][5][2] = cClosed;

//Tick 3
assign moves[moveForward][0][3] = negNinety;
assign moves[moveForward][1][3] = zero; 
assign moves[moveForward][2][3] = zero;
assign moves[moveForward][3][3] = cClosed;
assign moves[moveForward][4][3] = cOpen;
assign moves[moveForward][5][3] = cClosed;

//Tick 4
assign moves[moveForward][0][4] = zero;
assign moves[moveForward][1][4] = zero; 
assign moves[moveForward][2][4] = negNinety;
assign moves[moveForward][3][4] = cClosed;
assign moves[moveForward][4][4] = cOpen;
assign moves[moveForward][5][4] = cClosed;

//Tick 5
assign moves[moveForward][0][5] = zero;
assign moves[moveForward][1][5] = zero; 
assign moves[moveForward][2][5] = negNinety;
assign moves[moveForward][3][5] = cClosed;
assign moves[moveForward][4][5] = cClosed;
assign moves[moveForward][5][5] = cClosed;

//Tick 6
assign moves[moveForward][0][6] = zero;
assign moves[moveForward][1][6] = zero; 
assign moves[moveForward][2][6] = negNinety;
assign moves[moveForward][3][6] = cClosed;
assign moves[moveForward][4][6] = cClosed;
assign moves[moveForward][5][6] = cOpen;

//Tick 7
assign moves[moveForward][0][7] = zero;
assign moves[moveForward][1][7] = zero; 
assign moves[moveForward][2][7] = zero;
assign moves[moveForward][3][7] = cClosed;
assign moves[moveForward][4][7] = cClosed;
assign moves[moveForward][5][7] = cOpen;

//Tick 8
assign moves[moveForward][0][8] = zero;
assign moves[moveForward][1][8] = zero; 
assign moves[moveForward][2][8] = zero;
assign moves[moveForward][3][8] = cClosed;
assign moves[moveForward][4][8] = cClosed;
assign moves[moveForward][5][8] = cClosed;

////---------------------------------------------////
//--------Rotate Toward You------------------------//
////---------------------------------------------////

assign numMoves[moveBackward] = 5'd9;

//Tick 0
assign moves[moveBackward][0][0] = zero;
assign moves[moveBackward][1][0] = zero; 
assign moves[moveBackward][2][0] = zero;
assign moves[moveBackward][3][0] = cOpen;
assign moves[moveBackward][4][0] = cClosed;
assign moves[moveBackward][5][0] = cClosed;

//Tick 1
assign moves[moveBackward][0][1] = posNinety;
assign moves[moveBackward][1][1] = zero; 
assign moves[moveBackward][2][1] = zero;
assign moves[moveBackward][3][1] = cOpen;
assign moves[moveBackward][4][1] = cClosed;
assign moves[moveBackward][5][1] = cClosed;

//Tick 2
assign moves[moveBackward][0][2] = posNinety;
assign moves[moveBackward][1][2] = zero; 
assign moves[moveBackward][2][2] = zero;
assign moves[moveBackward][3][2] = cClosed;
assign moves[moveBackward][4][2] = cClosed;
assign moves[moveBackward][5][2] = cClosed;

//Tick 3
assign moves[moveBackward][0][3] = posNinety;
assign moves[moveBackward][1][3] = zero; 
assign moves[moveBackward][2][3] = zero;
assign moves[moveBackward][3][3] = cClosed;
assign moves[moveBackward][4][3] = cOpen;
assign moves[moveBackward][5][3] = cClosed;

//Tick 4
assign moves[moveBackward][0][4] = zero;
assign moves[moveBackward][1][4] = zero; 
assign moves[moveBackward][2][4] = posNinety;
assign moves[moveBackward][3][4] = cClosed;
assign moves[moveBackward][4][4] = cOpen;
assign moves[moveBackward][5][4] = cClosed;

//Tick 5
assign moves[moveBackward][0][5] = zero;
assign moves[moveBackward][1][5] = zero; 
assign moves[moveBackward][2][5] = posNinety;
assign moves[moveBackward][3][5] = cClosed;
assign moves[moveBackward][4][5] = cClosed;
assign moves[moveBackward][5][5] = cClosed;

//Tick 6
assign moves[moveBackward][0][6] = zero;
assign moves[moveBackward][1][6] = zero; 
assign moves[moveBackward][2][6] = posNinety;
assign moves[moveBackward][3][6] = cClosed;
assign moves[moveBackward][4][6] = cClosed;
assign moves[moveBackward][5][6] = cOpen;

//Tick 7
assign moves[moveBackward][0][7] = zero;
assign moves[moveBackward][1][7] = zero; 
assign moves[moveBackward][2][7] = zero;
assign moves[moveBackward][3][7] = cClosed;
assign moves[moveBackward][4][7] = cClosed;
assign moves[moveBackward][5][7] = cOpen;

//Tick 8
assign moves[moveBackward][0][8] = zero;
assign moves[moveBackward][1][8] = zero; 
assign moves[moveBackward][2][8] = zero;
assign moves[moveBackward][3][8] = cClosed;
assign moves[moveBackward][4][8] = cClosed;
assign moves[moveBackward][5][8] = cClosed;

////---------------------------------------------////
//--------Reset Cube Position----------------------//
////---------------------------------------------////

assign numMoves[resetYourself] = 5'd9;

//Tick 0
assign moves[resetYourself][0][0] = zero;
assign moves[resetYourself][1][0] = zero; 
assign moves[resetYourself][2][0] = zero;
assign moves[resetYourself][3][0] = cClosed;
assign moves[resetYourself][4][0] = cClosed;
assign moves[resetYourself][5][0] = cClosed;

//Tick 1
assign moves[resetYourself][0][1] = posNinety;
assign moves[resetYourself][1][1] = zero; 
assign moves[resetYourself][2][1] = posNinety;
assign moves[resetYourself][3][1] = cClosed;
assign moves[resetYourself][4][1] = cClosed;
assign moves[resetYourself][5][1] = cClosed;

//Tick 2
assign moves[resetYourself][0][2] = zero;
assign moves[resetYourself][1][2] = zero; 
assign moves[resetYourself][2][2] = zero;
assign moves[resetYourself][3][2] = cClosed;
assign moves[resetYourself][4][2] = cClosed;
assign moves[resetYourself][5][2] = cClosed;

//Tick 3
assign moves[resetYourself][0][3] = negNinety;
assign moves[resetYourself][1][3] = zero; 
assign moves[resetYourself][2][3] = negNinety;
assign moves[resetYourself][3][3] = cClosed;
assign moves[resetYourself][4][3] = cClosed;
assign moves[resetYourself][5][3] = cClosed;

//Tick 4
assign moves[resetYourself][0][4] = zero;
assign moves[resetYourself][1][4] = zero; 
assign moves[resetYourself][2][4] = zero;
assign moves[resetYourself][3][4] = cClosed;
assign moves[resetYourself][4][4] = cClosed;
assign moves[resetYourself][5][4] = cClosed;

//Tick 5
assign moves[resetYourself][0][5] = zero;
assign moves[resetYourself][1][5] = posNinety; 
assign moves[resetYourself][2][5] = zero;
assign moves[resetYourself][3][5] = cClosed;
assign moves[resetYourself][4][5] = cClosed;
assign moves[resetYourself][5][5] = cClosed;

//Tick 6
assign moves[resetYourself][0][6] = zero;
assign moves[resetYourself][1][6] = zero; 
assign moves[resetYourself][2][6] = zero;
assign moves[resetYourself][3][6] = cClosed;
assign moves[resetYourself][4][6] = cClosed;
assign moves[resetYourself][5][6] = cClosed;

//Tick 7
assign moves[resetYourself][0][7] = zero;
assign moves[resetYourself][1][7] = negNinety; 
assign moves[resetYourself][2][7] = zero;
assign moves[resetYourself][3][7] = cClosed;
assign moves[resetYourself][4][7] = cClosed;
assign moves[resetYourself][5][7] = cClosed;

//Tick 8
assign moves[resetYourself][0][8] = zero;
assign moves[resetYourself][1][8] = zero; 
assign moves[resetYourself][2][8] = zero;
assign moves[resetYourself][3][8] = cClosed;
assign moves[resetYourself][4][8] = cClosed;
assign moves[resetYourself][5][8] = cClosed;
