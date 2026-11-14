
// function SimpleFunction.test 2
// ローカル変数を0で初期化する
// ローカル変数の数は2なので、LCL[0]とLCL[1]を0にする
(SimpleFunction.test)
@LCL
A=M
M=0
A=A+1
M=0
// 引数の数に応じて繰り返す
// A=A+1
// M=0

// push local 0
@LCL
A=M
D=M
@SP
AM=M+1
A=A-1
M=D

// 略
// push local 1
// add
// not
// push argument 0
// add
// push argument 1
// sub

// return
// frame = LCL
// R13にLCLを退避
@LCL
D=M
@R13
M=D
// retAddr = *(frame-5)
// R14にretAddrを退避
@5
D=A
@R13
D=M-D // frame-5
@R14
M=D
// *ARG = pop()
@SP
A=M-1
D=M
@ARG
A=M
M=D
// SP = ARG+1
@ARG
D=M+1
@SP
M=D
// THAT = *(frame-1)
@R13
AM=M-1 // 316
D=M // Dに316番地の値が入る
@THAT
M=D
// THIS = *(frame-2)
@R13
AM=M-1
D=M
@THIS
M=D
// ARG = *(frame-3)
@R13
AM=M-1
D=M
@ARG
M=D
// LCL = *(frame-4)
@R13
AM=M-1
D=M
@LCL
M=D
// goto retAddr
@R14
A=M
0;JMP

