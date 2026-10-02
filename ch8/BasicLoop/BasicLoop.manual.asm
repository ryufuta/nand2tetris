// push constan 0
@0
D=A
@SP
AM=M+1
A=A-1
M=D


// pop local 0         // initializes sum = 0
@SP
AM=M-1
D=M
@LCL
A=M
M=D

// label LOOP_START
(LOOP_START)

// push argument 0    
@ARG
A=M
D=M
@SP
AM=M+1
A=A-1
M=D

// push local 0
@LCL
A=M
D=M
@SP
AM=M+1
A=A-1
M=D

// add
// pop local 0	        // sum = sum + counter
// push argument 0
// push constant 1
// sub
// pop argument 0      // counter--
// push argument 0

// if-goto LOOP_START  // If counter != 0, goto LOOP_START
@SP
AM=M-1
D=M
@LOOP_START
D;JNE

// push local 0
