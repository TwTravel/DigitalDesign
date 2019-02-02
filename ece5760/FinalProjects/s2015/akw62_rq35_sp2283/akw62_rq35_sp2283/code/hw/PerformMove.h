
//Define the parameters
parameter uClock  = 0;
parameter uCClock = 1;
parameter dClock  = 2;
parameter dCClock = 3;
parameter bClock  = 4;
parameter bCClock = 5;
parameter fClock  = 6;
parameter fCClock = 7;
parameter lClock  = 8;
parameter lCClock = 9;
parameter rClock  = 10;
parameter rCClock = 11;
parameter hRotate = 12;
parameter vRotate = 13;
parameter phyHRotate = 14;
parameter phyVRotate = 15;

//Face that needs to be manipulated
parameter upFace    = 0;
parameter downFace  = 1;
parameter backFace  = 2;
parameter frontFace = 3;
parameter leftFace  = 4;
parameter rightFace = 5;
parameter fullRotate = 6;

//Direction face needs to be rotated
parameter clockwise        = 0;
parameter counterClockwise = 1;
parameter horizontal       = 2;
parameter vertical         = 3;
parameter phyHorizontal    = 4;
parameter phyVertical      = 5;

//Direction to rotate cube to get to correct spot
parameter noCubeRotation    = 0;
parameter rotateCubeForward = 1;
parameter rotateCubeBack    = 2;

//Since a move can be comprised of multiple, this holds the current
reg [3:0] currentMoveToExecute;

//Holding the current cube position
reg [2:0] currentUp/* synthesis keep preserve */;
reg [2:0] currentDown/* synthesis keep preserve */;
reg [2:0] currentBack/* synthesis keep preserve */;
reg [2:0] currentFront/* synthesis keep preserve */;
reg [2:0] currentLeft/* synthesis keep preserve */;
reg [2:0] currentRight/* synthesis keep preserve */;

reg [2:0] rotateFace/* synthesis keep preserve */;
reg [2:0] rotateDir/* synthesis keep preserve */;

reg       finishedMoves;
reg [9:0] moveCount;

//Move state machine
always@(posedge stateClock)
begin

if(SW[0])
begin  
   //Make sure the cube is in the home position
   readAddress   <= 0;
   finishedMoves <= 1;
   moveCount     <= 0;
   currentPos[0] <= positions[0][zero];
   currentPos[1] <= positions[1][zero];
   currentPos[2] <= positions[2][zero];
   currentPos[3] <= positions[3][cPartialOpen];
   currentPos[4] <= positions[4][cPartialOpen];
   currentPos[5] <= positions[5][cPartialOpen];
   state <= idle;
end
else if(cubeReset)
begin
   //Make sure the cube is in the home position
   readAddress   <= 0;
   finishedMoves <= 1;
   moveCount     <= 0;
   currentPos[0] <= positions[0][zero];
   currentPos[1] <= positions[1][zero];
   currentPos[2] <= positions[2][zero];
   currentPos[3] <= positions[3][cClosed];
   currentPos[4] <= positions[4][cClosed];
   currentPos[5] <= positions[5][cClosed];
   state <= idle;
   
   //Reset variables
   currentCommand <= 0;
   currentMove    <= 0;
   currentDelay   <= 0;
   
   //Set initial cube faces
   currentUp    <= upFace;
   currentDown  <= downFace;
   currentBack  <= backFace;
   currentFront <= frontFace;
   currentLeft  <= leftFace;
   currentRight <= rightFace;
   
   rotateFace <= frontFace;
   rotateDir  <= clockwise;
   
   currentMoveToExecute <= moveNone;
end
else 
begin
   case(state)
      startup: begin
         finishedMoves <= 0;
         currentPos[0] <= positions[0][zero];
         currentPos[1] <= positions[1][zero];
         currentPos[2] <= positions[2][zero];
         currentPos[3] <= positions[3][cOpen];
         currentPos[4] <= positions[4][cClosed];
         currentPos[5] <= positions[5][cOpen];
         state <= idle;
         moveCount     <= 0;
      end
      idle: begin
   
         //FIFO is not empty, start a move
         if(readAddress < cubeAddress && cubeAddress > 0)
         begin
            state <= startMove;
            finishedMoves <= 0;
         end
       else if(finished)
       begin
         finishedMoves <= 1;
         currentPos[0] <= positions[0][zero];
         currentPos[1] <= positions[1][zero];
         currentPos[2] <= positions[2][zero];
         currentPos[3] <= positions[3][cOpen];
         currentPos[4] <= positions[4][cOpen];
         currentPos[5] <= positions[5][cOpen];
       end
       else
       begin
         finishedMoves <= 1;
       end
         
         //Reset variables
         currentMove <= 0;
         currentDelay <= 0;
         returnState <= startMove;
         currentMoveToExecute <= moveNone;
      end
      startMove: begin
         //See if we need to do a calibration
		 if(moveCount > 7) begin
		    state <= move;
			currentMoveToExecute <= resetYourself;
			 currentMove  <= 0;
			 currentDelay <= 0;
			 returnState <= moveFinished;
			 moveCount <= 0;
		 end
		 else
		 begin
			 //Grab the move out of memory and make sure the servos are enabled
			 readAddress <= readAddress + 1;
			 currentCommand <= readData[3:0];
			 servoEnable <= 1;
			 state <= determineFace;
			 moveCount <= moveCount + 1;
		 end
      end
      determineFace: begin
         //Figure out what face needs to be rotated
         case(currentCommand)
            uClock: begin
               rotateFace <= upFace;
               rotateDir  <= clockwise;
            end
            uCClock: begin
               rotateFace <= upFace;
               rotateDir  <= counterClockwise;
            end
            dClock: begin
               rotateFace <= downFace;
               rotateDir  <= clockwise;
            end
            dCClock: begin
               rotateFace <= downFace;
               rotateDir  <= counterClockwise;
            end
            bClock: begin
               rotateFace <= backFace;
               rotateDir  <= clockwise;
            end
            bCClock: begin
               rotateFace <= backFace;
               rotateDir  <= counterClockwise;
            end
            fClock: begin
               rotateFace <= frontFace;
               rotateDir  <= clockwise;
            end
            fCClock: begin
               rotateFace <= frontFace;
               rotateDir  <= counterClockwise;
            end
            lClock: begin
               rotateFace <= leftFace;
               rotateDir  <= clockwise;
            end
            lCClock: begin
               rotateFace <= leftFace;
               rotateDir  <= counterClockwise;
            end
            rClock: begin
               rotateFace <= rightFace;
               rotateDir  <= clockwise;
            end
            rCClock: begin
               rotateFace <= rightFace;
               rotateDir  <= counterClockwise;
            end
            hRotate: begin
               rotateFace <= fullRotate;
               rotateDir  <= horizontal;
            end
            vRotate: begin
               rotateFace <= fullRotate;
               rotateDir  <= vertical;
            end
         phyHRotate: begin
            rotateFace <= fullRotate;
            rotateDir  <= phyHorizontal;
         end
         phyVRotate: begin
            rotateFace <= fullRotate;
            rotateDir  <= phyVertical;
         end
         default: begin
         end
         endcase
         state <= determineRotation;
      end
      
      //Decide which direction to rotate the full cube
      determineRotation: begin
         if((rotateFace == currentUp) || (rotateFace == currentBack))
         begin
            //Cube needs to be rotate towards you
            currentUp    <= currentBack;
            currentDown  <= currentFront;
            currentBack  <= currentDown;
            currentFront <= currentUp;
            
            currentMoveToExecute <= moveForward;
            state        <= move;
            returnState  <= determineRotation;
            currentMove  <= 0;
         end
         else if(rotateFace == currentDown)
         begin
            //Cube needs to be rotated away from you
            currentUp    <= currentFront;
            currentDown  <= currentBack;
            currentBack  <= currentUp;
            currentFront <= currentDown;
            
            currentMoveToExecute <= moveBackward;
            state        <= move;
            returnState  <= determineRotation;
            currentMove  <= 0;
         end
       else if(rotateFace == fullRotate && rotateDir == phyVertical)
       begin
         //Cube needs to be rotated away from you
            currentUp    <= currentFront;
            currentDown  <= currentBack;
            currentBack  <= currentUp;
            currentFront <= currentDown;
            
            currentMoveToExecute <= moveBackward;
            state        <= move;
            returnState  <= moveFinished;
            currentMove  <= 0;
       end
         else if(rotateFace == fullRotate && rotateDir == horizontal)
         begin
       
         if(currentFront == upFace) begin
            currentUp    <= currentRight;
            currentLeft  <= currentUp;
            currentDown  <= currentLeft;
            currentRight <= currentDown;
         end
         else if(currentUp == upFace) begin
            //Rotate clockwise
            currentBack  <= currentRight;
            currentFront <= currentLeft;
            currentLeft  <= currentBack;
            currentRight <= currentFront;
         end
         else if(currentBack == upFace) begin 
            currentUp    <= currentLeft;
            currentLeft  <= currentDown;
            currentDown  <= currentRight;
            currentRight <= currentUp;
         end
         else if(currentDown == upFace) begin 
            currentBack  <= currentLeft;
            currentFront <= currentRight;
            currentLeft  <= currentFront;
            currentRight <= currentBack;
         end
         else if(currentLeft == upFace) begin 
            currentUp    <= currentFront;
            currentFront <= currentDown;
            currentDown  <= currentBack;
            currentBack  <= currentUp;
         end
         else if(currentRight == upFace) begin 
            currentUp    <= currentBack;
            currentFront <= currentUp;
            currentDown  <= currentFront;
            currentBack  <= currentDown;
         end
            state <= moveFinished;
         end
         else if(rotateFace == fullRotate && rotateDir == vertical)
         begin

         
         if(currentFront == leftFace) begin
            currentUp    <= currentRight;
            currentRight <= currentDown;
            currentDown  <= currentLeft;
            currentLeft  <= currentUp;
         end
         else if(currentLeft == leftFace) begin
            //Rotate away from you
            currentUp    <= currentFront;
            currentDown  <= currentBack;
            currentBack  <= currentUp;
            currentFront <= currentDown;
         end
         else if(currentBack == leftFace) begin 
            currentUp    <= currentLeft;
            currentRight <= currentUp;
            currentDown  <= currentRight;
            currentLeft  <= currentDown;
         end
         else if(currentDown == leftFace) begin 
            currentFront <= currentRight;
            currentRight <= currentBack;
            currentBack  <= currentLeft;
            currentLeft  <= currentFront;
         end
         else if(currentUp == leftFace) begin 
            currentFront <= currentLeft;
            currentRight <= currentFront;
            currentBack  <= currentLeft;
            currentLeft  <= currentBack;
         end
         else if(currentRight == leftFace) begin 
            currentUp    <= currentBack;
            currentDown  <= currentFront;
            currentBack  <= currentDown;
            currentFront <= currentUp;
         end
         
            state <= moveFinished; //Moving is finished
         end
         else
       begin
            //No full cube rotation necessary
            state <= determineRotateCommand;
         end
      end
      
      determineRotateCommand: begin
         if((rotateFace == currentLeft) && (rotateDir == clockwise))
         begin
            currentMoveToExecute <= moveLeftClock;
         end
         else if((rotateFace == currentLeft) && (rotateDir == counterClockwise))
         begin
            currentMoveToExecute <= moveLeftCounterClock;
         end
         else if((rotateFace == currentRight) && (rotateDir == clockwise))
         begin
            currentMoveToExecute <= moveRightClock;
         end
         else if((rotateFace == currentRight) && (rotateDir == counterClockwise))
         begin
            currentMoveToExecute <= moveRightCounterClock;
         end
         else if((rotateFace == currentFront) && (rotateDir == clockwise))
         begin
            currentMoveToExecute <= moveFrontClock;
         end
         else if((rotateFace == currentFront) && (rotateDir == counterClockwise))
         begin
            currentMoveToExecute <= moveFrontCounterClock;
         end
         
         state        <= move;
         returnState  <= moveFinished;
         currentMove  <= 0;
         currentDelay <= 0;
      end
      
      move: begin
         for(servoNum = 0; servoNum < 6; servoNum = servoNum + 1)
         begin
            currentPos[servoNum] <= positions[servoNum][moves[currentMoveToExecute][servoNum][currentMove]];
         end
         state <= moveDelay;
      end
      
      moveDelay: begin
         if(currentMove < (numMoves[currentMoveToExecute] - 1))
         begin
            if(currentDelay < delay)
            begin
               currentDelay <= currentDelay + 1;
            end
            else
            begin
               state <= move;
               currentMove <= currentMove + 1;
               currentDelay <= 0;
            end
         end
         else if (currentMove < numMoves[currentMoveToExecute])
         begin
            if(currentDelay < delay)
            begin
               currentDelay <= currentDelay + 1;
            end
            else
            begin
               currentMove <= currentMove + 1;
               currentDelay <= 0;
            end
         end
         else
         begin
            state <= returnState;
            currentDelay <= 0;
            currentMove  <= 0;
         end
      end
      moveFinished: begin
         //Do any cleanup here
         state <= idle;
      end
      default: begin
         state <= idle;
      end   
   endcase
end
end
