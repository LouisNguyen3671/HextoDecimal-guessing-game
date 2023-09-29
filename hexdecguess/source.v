`timescale 1ns / 1ps

module Top(
    input CLK,BTNC,BTNU,BTNL,BTNR,BTND,
    input [15:0] SW,
    output [15:0] LED,
    output [7:0] SSEG_CA,
    output [7:0] SSEG_AN
    );
    
    reg [4:0] i;
    reg [4:0] State;
    
    reg  [3:0] Ppoint;
    reg  [2:0] CSC;
    
    reg [3:0] Random [0:3];  //random number value
    reg [15:0] RLed;
    reg [4:0]Digit [0:7];
    reg [31:0] Counter;
    reg Clk_1K, Clk_Slow, Clk_Flash, Clk_Slide;
    wire [39:0] Pass;
    reg [4:0] RPass [7:0];   //pass value
    reg [4:0] RSave [7:0];   //save value
    wire [7:0] Dp;
    reg [3:0] Value;
    reg [2:0] Sl_Start;
    reg [2:0] Sl_End;
    reg [2:0]  i_Guess;   //index for number of guess
    reg [2:0]  iD_Guess;  //index for digit gess
    reg  Bity;
    
    
    
    initial begin   //counter start from zero
    i<= 5'b00000;
    State <= 5'b00000;
    Clk_1K <= 1'b0;
    Clk_Slow <= 1'b0;
    Clk_Slide <= 1'b0;
    Clk_Flash <= 1'b0;
    RLed = 16'h0000;
    end
    
   always @ (posedge CLK) begin
        Counter <= Counter + 32'h00000001;
        Clk_1K <= Counter [10];
        Clk_Slow <= Counter[26];
        Clk_Slide <= Counter[25];
        Clk_Flash <= Counter[22];
        end
        
    always @ (posedge Clk_1K) begin
    case (State)  //5 bit state to go through code
      5'b00000 : begin
                Bity = 1'b1;
                for (i=0; i< 4'b1000; i = i + 4'b0001) begin
                    RPass[i] <= 5'b00000;
                    RSave[i] <= 5'b00000;
                end
                i_Guess <= 3'b000;
                iD_Guess <= 3'b000;
                if(BTNC == 1'b1) begin
                    Bity <= 1'b0;   //1 time only
                    State <= State + 5'b00001;
                    Random[0]  = {Counter[2],Counter[4],1'b1,Counter[3]};
                    Random[1]  = {Counter[6],Counter[7],Counter[19],Counter[1]};
                    Random[2]   = {Counter[5],Counter[9],Counter[13],Counter[20]};
                    Random[3] = {Counter[8],Counter[11],Counter[16],Counter[12]};
                end
      end
      5'b00001 : begin
                RPass[7] <= {1'b1,Random[3]};
                RPass[6] <= {1'b1,Random[2]};
                RPass[5] <= {1'b1,Random[1]};
                RPass[4] <= {1'b1,Random[0]};
                RPass[3] <= 5'b00000;
                RPass[2] <= 5'b00000;
                RPass[1] <= 5'b00000;
                RPass[0] <= 5'b00000;
                if(Clk_Flash)State <= State;
                else State <= State+5'b00001;
      end 
      5'b00010 : begin
                RPass[6] <= {1'b1,Random[3]};
                RPass[5] <= {1'b1,Random[2]};
                RPass[4] <= {1'b1,Random[1]};
                RPass[3] <= {1'b1,Random[0]};
                RPass[2] <= 5'b00000;
                RPass[1] <= 5'b00000;
                RPass[0] <= 5'b00000;
                RPass[7] <= 5'b00000;
                if(!Clk_Flash) State <= State;
                else State <= State+5'b00001;     
      end
      5'b00011 : begin
                RPass[5] <= {1'b1,Random[3]};
                RPass[4] <= {1'b1,Random[2]};
                RPass[3] <= {1'b1,Random[1]};
                RPass[2] <= {1'b1,Random[0]};
                RPass[1] <= 5'b00000;
                RPass[0] <= 5'b00000;
                RPass[7] <= 5'b00000;
                RPass[6] <= 5'b00000;
                if(Clk_Flash)State <= State;
                else State <= State+5'b00001;    
      end
      5'b00100 : begin
                RPass[4] <= {1'b1,Random[3]};
                RPass[3] <= {1'b1,Random[2]};
                RPass[2] <= {1'b1,Random[1]};
                RPass[1] <= {1'b1,Random[0]};
                RPass[0] <= 5'b00000;
                RPass[7] <= 5'b00000;
                RPass[6] <= 5'b00000;
                RPass[5] <= 5'b00000;      
                if(!Clk_Flash)State <= State;
                else State <= State+5'b00001;    
      
      end                  
      5'b00101 : begin
                RPass[3] <= {1'b1,Random[3]};
                RPass[2] <= {1'b1,Random[2]};
                RPass[1] <= {1'b1,Random[1]};
                RPass[0] <= {1'b1,Random[0]};
                RPass[7] <= 5'b00000;
                RPass[6] <= 5'b00000;
                RPass[5] <= 5'b00000;
                RPass[4] <= 5'b00000;
                if(Clk_Flash)State <= State;
                else State <= State+5'b00001;
      end
      5'b00110 : begin
                RPass[3] <= 5'b00000;
                RPass[2] <= {1'b1,Random[3]};
                RPass[1] <= {1'b1,Random[2]};
                RPass[0] <= {1'b1,Random[1]};
                RPass[7] <= 5'b00000;
                RPass[6] <= 5'b00000;
                RPass[5] <= 5'b00000;
                RPass[4] <= 5'b00000;
                if(!Clk_Flash)State <= State;
                else State <= State+5'b00001;      
      end
      5'b00111 : begin
                RPass[3] <= 5'b00000;
                RPass[2] <= 5'b00000;
                RPass[1] <= {1'b1,Random[3]};
                RPass[0] <= {1'b1,Random[2]};
                RPass[7] <= 5'b00000;
                RPass[6] <= 5'b00000;
                RPass[5] <= 5'b00000;
                RPass[4] <= 5'b00000;
                if(Clk_Flash)State <= State;
                else State <= State+5'b00001;      
      end
      5'b01000 : begin
                RPass[3] <= 5'b00000;
                RPass[2] <= 5'b00000;
                RPass[1] <= 5'b00000;
                RPass[0] <= {1'b1,Random[3]};
                RPass[7] <= 5'b00000;
                RPass[6] <= 5'b00000;
                RPass[5] <= 5'b00000;
                RPass[4] <= 5'b00000;
                if(!Clk_Flash)State <= State;
                else State <= State+5'b00001;       
      end    
      5'b01001 : begin
           if (BTNR) begin                      
                RPass[3] <= {1'b1,Random[3]};
                RPass[2] <= {1'b1,Random[2]};
                RPass[1] <= {1'b1,Random[1]};
                RPass[0] <= {1'b1,Random[0]};
                RPass[7] <= 5'b00000;
                RPass[6] <= 5'b00000;
                RPass[5] <= 5'b00000;
                RPass[4] <= 5'b00000;
            end
            else begin
                RPass[6] <= 5'b00000;
                RPass[7] <= 5'b00000;
                RPass[0] <= 5'b00000;
                RPass[1] <= 5'b00000;
                RPass[2] <= 5'b00000;
                RPass[3] <= 5'b00000;
                RPass[4] <= 5'b00000;
                RPass[5] <= 5'b00000;
            end
                if(Clk_Flash)State <= State;
                else begin
                        i_Guess  <= 3'b000;  
                        iD_Guess <= 3'b011;   
                        State <= State + 5'b00001;  
                end
      end 
      5'b01010 : begin   //guess time
                if(BTND && Clk_Slow) begin               
                    for (i=0 ; i <5'b10000 ; i = i + 5'b00001) begin  
                        if(SW[i]) Value = i[3:0];  
                    end
                    RPass[3'b111 - i_Guess] <= {1'b1,Value};   //display the value (add in the display bit)
                    
         
                    
                    if (Value > Random[iD_Guess]) begin  //Check HI  Compare the guess to the correct random digit
                        RLed[15] = 1'b1;
                        RLed[0] = 1'b0;
                        RLed[14:1] =14'b00000000000000;
                        State <= 5'b01011;   //go to B State
                    end
                    else if (Value < Random[iD_Guess]) begin //Check Low
                        RLed[15] = 1'b0;
                        RLed[0] = 1'b1; 
                        RLed[14:1] =14'b00000000000000;
                        State <= 5'b01011;   //go to B state                        
                    end
                    else if (Value == Random[iD_Guess])begin   //Guess is correct
                        RLed = 16'hFFFF;   
                        State <= 5'b01100;     //guess correct state C                                        
                    end
             
               end
      end 
      5'b01011 : begin   //  STATE B
                if (!Clk_Slow && !BTND) begin
                    State = 5'b01010;
                    i_Guess = i_Guess + 3'b001;
                    if (i_Guess == 3'b100) State = 5'b10111;   //goto lose state
                end
      end             
      5'b01100 : begin   // STATE C
                if (!Clk_Slide) begin    
                    State = State + 5'b00001;  
                    Sl_End = iD_Guess;   
                    Sl_Start = 3'b111 - i_Guess;
                    for (i= 5'b00000; i< 5'b00100 ; i = i + 5'b00001) begin 
                        RSave[i] <= RPass[i];
                    end
                    RSave[7] <= 5'b00000;
                    RSave[6] <= 5'b00000;
                    RSave[5] <= 5'b00000;
                    RSave[4] <= 5'b00000;
                 end
       end
       5'b01101  : begin   // stae D
                if (Clk_Slide) begin 
                    RLed = 16'h0000;  
                    State = State + 5'b00001; 
                    RPass[Sl_Start] = RSave[Sl_Start];  
                    Sl_Start = Sl_Start - 3'b001;  
                    RPass[Sl_Start] = {1'b1,Value};  
                    if(Sl_Start == Sl_End) State = 5'b10100;                   
                end                    
      end
      5'b01110 : begin  
                if (!Clk_Slide) begin 
                      State = State + 5'b00001;  
                      RPass[Sl_Start] = RSave[Sl_Start];  
                      Sl_Start = Sl_Start - 3'b001;  
                      RPass[Sl_Start] = {1'b1,Value};   
                      if(Sl_Start == Sl_End) State = 5'b10100; 
                end    
      end
      5'b01111 : begin
                if (Clk_Slide) begin  
                      State = State + 5'b00001;   
                      RPass[Sl_Start] = RSave[Sl_Start];   
                      Sl_Start = Sl_Start - 3'b001;   
                      RPass[Sl_Start] = {1'b1,Value};   
                      if(Sl_Start == Sl_End) State = 5'b10100;  
                end        
      end
      5'b10000 : begin
                if (!Clk_Slide) begin  
                      State = State + 5'b00001;   
                      RPass[Sl_Start] = RSave[Sl_Start];  
                      Sl_Start = Sl_Start - 3'b001;   
                      RPass[Sl_Start] = {1'b1,Value};   
                      if(Sl_Start == Sl_End) State = 5'b10100;  
                end         
      end
      5'b10001 : begin
                if (Clk_Slide) begin  
                      State = State + 5'b00001;   
                      RPass[Sl_Start] = RSave[Sl_Start];  
                      Sl_Start = Sl_Start - 3'b001;  
                      RPass[Sl_Start] = {1'b1,Value};  
                      if(Sl_Start == Sl_End) State = 5'b10100;  
                end         
      end
      5'b10010 : begin
                 if (!Clk_Slide) begin  
                      State = State + 5'b00001;  
                      RPass[Sl_Start] = RSave[Sl_Start];   
                      Sl_Start = Sl_Start - 3'b001;  
                      RPass[Sl_Start] = {1'b1,Value};   
                      if(Sl_Start == Sl_End) State = 5'b10100;  
                 end       
      end
      5'b10011 : begin
                if (Clk_Slide) begin 
                      State <= 5'b10100;  
                      RPass[Sl_Start] = RSave[Sl_Start];   
                      Sl_Start = Sl_Start - 3'b001;  
                      RPass[Sl_Start] = {1'b1,Value};  
                end        
      end
      5'b10100 : begin    
                if (!Clk_Slide) begin  
                    State = 5'b01010;                 
                    if(iD_Guess == 3'b000) State = 5'b10101;  
                    RSave[7] <= 5'b00000;
                    RSave[6] <= 5'b00000;
                    RSave[5] <= 5'b00000;
                    RSave[4] <= 5'b00000;
                    RPass[7] <= 5'b00000;
                    RPass[6] <= 5'b00000;
                    RPass[5] <= 5'b00000;
                    RPass[4] <= 5'b00000;
                    iD_Guess <= iD_Guess - 3'b001;  
                    i_Guess <= 3'b000;

                end     
      end
      5'b10101 : begin    
                if(BTNC) State = 5'b00000;   
                if(Clk_Slow) begin
                    RLed <= 8'b11111111;
                    RPass[3] <= {1'b1,Random[3]};
                    RPass[2] <= {1'b1,Random[2]};
                    RPass[1] <= {1'b1,Random[1]};
                    RPass[0] <= {1'b1,Random[0]};
                    RPass[7] <= 5'b00000;
                    RPass[6] <= 5'b00000;
                    RPass[5] <= 5'b00000;
                    RPass[4] <= 5'b00000; 
                    State = State + 5'b00001;              
                end
      
      end
      5'b10110 : begin   
                if(BTNC) State = 5'b00000;    
                if(!Clk_Slow) begin
                    RLed <= 8'b00000000;
                    RPass[3] <= 5'b00000;
                    RPass[2] <= 5'b00000;
                    RPass[1] <= 5'b00000;
                    RPass[0] <= 5'b00000;
                    
                    
                    RPass[7] <= 5'b00000;
                    
                    RPass[6] <= {1'b1,Ppoint};
                    
                    RPass[5] <= 5'b10000;
                    RPass[4] <= 5'b10000; 
                    State = State - 5'b00001;              
                end  
      end
      //loser time
       5'b10111 : begin   
                 if(BTNC) State <= 5'b00000;        
                 if (Clk_Slow) begin 
                    State =State + 5'b00001;
                    RPass[7] <= 5'b11111;
                    RPass[6] <= 5'b10000;
                    RPass[5] <= 5'b10000;
                    RPass[4] <= 5'b10000;
                    RPass[3] <= {1'b1,Random[3]};  
                    RPass[2] <= {1'b1,Random[2]};
                    RPass[1] <= {1'b1,Random[1]};
                    RPass[0] <= {1'b1,Random[0]};                    
                 end
                 
       end
       5'b11000 : begin    
                 if(BTNC) State <= 5'b00000;       
                 if (!Clk_Slow) begin 
                    State =State - 5'b00001;
                    RPass[7] <= 5'b00000;
                    RPass[6] <= 5'b00000;
                    RPass[5] <= 5'b00000;
                    RPass[4] <= 5'b00000;
                 end
                 
       end
                            
      default : begin
            RLed <= 8'b10101010;
      end
    endcase
    end
    
    assign Pass = {RPass[0],RPass[1],RPass[2],RPass[3],RPass[4],RPass[5],RPass[6],RPass[7]};
    assign Dp = 8'h00;
    assign LED = RLed;
    
    Disp_7seg Inst_A (Pass,Dp,Clk_1K,SSEG_CA, SSEG_AN); //instantiate
    
    always @(posedge Clk_Slow)
    begin
   

    case (CSC)
        3'd000: Ppoint = 4'b0000;
        3'd001: Ppoint= 4'b0001;
        3'd010: Ppoint = 4'b0010;
        3'd011: Ppoint = 4'b0011;
        3'd100: Ppoint = 4'b0100;
        3'd101: Ppoint = 4'b0101;
        3'd110: Ppoint = 4'b0110;
        3'd111: Ppoint = 4'b0111;
        endcase
     if(iD_Guess == 3'b000) begin     
       CSC = CSC + 3'b001;
        end
    else if(iD_Guess != 3'b00) begin
    CSC = CSC - 3'b001;
    end
    end
endmodule
//____________________________________________________________________________________________________________
//____________________________________________________________________________________________________________


module Disp_7seg(
	input [0:39] Pd,
	input [7:0]  DP,
	input        Clk,
	output[7:0] SSC,   //The Segments
	output reg [7:0] SSA);  //The Digit
	
    wire    [4:0] Disp [0:7];
    reg     [2:0] Point;
    reg     [4:0] Point_Plus;
    
    wire [3:0] Digit_to_Show;

    
    initial begin
    Point <= 3'b000;
    end
     
    
    assign {Disp[0],Disp[1],Disp[2],Disp[3],Disp[4],Disp[5],Disp[6],Disp[7]}= Pd;  //Unpack, cant put 2-d array in port 
    //assign Segments = SSC;  
    
    always @(posedge Clk ) begin  //This increments the displayed digit at 1KHz
    Point <= Point + 3'b001;
    end
    
    assign Digit_to_Show = Disp[Point][3:0];
    
    Hex_Dig Inst1 (Digit_to_Show,SSC,DP[Point]);
    

    
    always @ (*) begin
          Point_Plus = {Disp [Point][4],Point};  //Adds the bit that selects for display or not
          case (Point_Plus)   
            4'b1000:SSA = ~(8'b00000001);   
            4'b1001:SSA = ~(8'b00000010);  
            4'b1010:SSA = ~(8'b00000100);   
            4'b1011:SSA = ~(8'b00001000);   
            4'b1100:SSA = ~(8'b00010000);   
            4'b1101:SSA = ~(8'b00100000);   
            4'b1110:SSA = ~(8'b01000000);   
            4'b1111:SSA = ~(8'b10000000);   
            default:SSA = ~(8'b00000000);   
     endcase   
       
    end
endmodule         
          
          
module Hex_Dig (        //hex digit modulke
        input [3:0] Value,
        output reg [7:0] SS,
        input Decimal_Point);
        
        always @ (*) begin
        case (Value) 
             4'h0:  SS[6:0] = ~(7'b0111111);    
             4'h1:  SS[6:0] = ~(7'b0000110);    
             4'h2:  SS[6:0] = ~(7'b1011011);   
             4'h3:  SS[6:0] = ~(7'b1001111);   
             4'h4:  SS[6:0] = ~(7'b1100110);   
             4'h5:  SS[6:0] = ~(7'b1101101);   
             4'h6:  SS[6:0] = ~(7'b1111101);   
             4'h7:  SS[6:0] = ~(7'b0000111);   
             4'h8:  SS[6:0] = ~(7'b1111111);   
             4'h9:  SS[6:0] = ~(7'b1100111);   
             4'hA:  SS[6:0] = ~(7'b1110111);   
             4'hB:  SS[6:0] = ~(7'b1111100);   
             4'hC:  SS[6:0] = ~(7'b0111001);   
             4'hD:  SS[6:0] = ~(7'b1011110);   
             4'hE:  SS[6:0] = ~(7'b1111001);   
             4'hF:  SS[6:0] = ~(7'b1110001);   
          default:  SS[6:0] = ~(7'b1001001);
        endcase
        SS[7] = ~Decimal_Point;   
           end
endmodule
