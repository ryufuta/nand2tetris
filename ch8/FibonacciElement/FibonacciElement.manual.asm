// Sys.initを呼ぶブートストラップ
@256
D=A
@SP
M=D
// call Sys.init
// push returnAddress
@$ret.0
D=A
@SP
AM=M+1
A=A-1
M=D
// push LCL
@LCL
D=M
@SP
AM=M+1
A=A-1
M=D
// push ARG
@ARG
D=M
@SP
AM=M+1
A=A-1
M=D
// push THIS
@THIS
D=M
@SP
AM=M+1
A=A-1
M=D
// push THAT
@THAT
D=M
@SP
AM=M+1
A=A-1
M=D
// ARG = SP-5-nArgs
@SP
D=M
@5
D=D-A
// nArgsはない
@ARG
M=D
// LCL = SP
@SP
D=M
@LCL
M=D
// goto f
@Sys.init
0;JMP
($ret.0)

// Sys.vm

// function Sys.init 0
// push constant 4
// call Main.fibonacci 1   // computes the 4'th fibonacci element
@Sys.init$ret.0
D=A
@SP
AM=M+1
A=A-1
M=D

// push LCL
@LCL
D=M
@SP
AM=M+1
A=A-1
M=D

// push ARG
@ARG
D=M
@SP
AM=M+1
A=A-1
M=D
// push THIS
@THIS
D=M
@SP
AM=M+1
A=A-1
M=D
// push THAT
@THAT
D=M
@SP
AM=M+1
A=A-1
M=D
// ARG = SP-5-nArgs
@SP
D=M
@5
D=D-A
@1 // nArgs
D=D-A
@ARG
M=D

// LCL = SP
@SP
D=M
@LCL
M=D
// goto f
@Main.fibonacci
0;JMP
(Sys.init$ret.0)


// label WHILE
// goto WHILE              // loops infinitely

// Main.vm

// function Main.fibonacci 0
// push argument 0
// push constant 2
// lt                     // checks if n<2
// if-goto IF_TRUE
@SP
AM=M-1
D=M
@Main.fibonacci$IF_TRUE
D;JNE

// goto IF_FALSE
@Main.fibonacci$IF_TRUE
0;JMP
// label IF_TRUE          // if n<2, return n
(Main.fibonacci$IF_TRUE)
// push argument 0        
// return
// label IF_FALSE         // if n>=2, returns fib(n-2)+fib(n-1)
(Main.fibonacci$IF_FALSE)
// push argument 0
// push constant 2
// sub

// call Main.fibonacci 1  // computes fib(n-2)
@Main.fibonacci$ret.0
D=A
@SP
AM=M+1
A=A-1
M=D

// push LCL
@LCL
D=M
@SP
AM=M+1
A=A-1
M=D

// push ARG
@ARG
D=M
@SP
AM=M+1
A=A-1
M=D
// push THIS
@THIS
D=M
@SP
AM=M+1
A=A-1
M=D
// push THAT
@THAT
D=M
@SP
AM=M+1
A=A-1
M=D
// ARG = SP-5-nArgs
@SP
D=M
@5
D=D-A
@1 // nArgs
D=D-A
@ARG
M=D

// LCL = SP
@SP
D=M
@LCL
M=D
// goto f
@Main.fibonacci
0;JMP
(Main.fibonacci$ret.0)
// push argument 0
// push constant 1
// sub
// call Main.fibonacci 1  // computes fib(n-1)
// add                    // returns fib(n-1) + fib(n-2)
// return
