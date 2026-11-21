(SimpleFunction.test)
@LCL
A=M
A=A-1
A=A+1
M=0
A=A+1
M=0
@0
D=A
@LCL
A=D+M
D=M
@SP
AM=M+1
A=A-1
M=D
@1
D=A
@LCL
A=D+M
D=M
@SP
AM=M+1
A=A-1
M=D
@SP
AM=M-1
D=M
A=A-1
M=D+M
@SP
A=M-1
M=!M
@0
D=A
@ARG
A=D+M
D=M
@SP
AM=M+1
A=A-1
M=D
@SP
AM=M-1
D=M
A=A-1
M=D+M
@1
D=A
@ARG
A=D+M
D=M
@SP
AM=M+1
A=A-1
M=D
@SP
AM=M-1
D=M
A=A-1
M=M-D
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
A=M-D // frame-5
D=M // *(frame-5)
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
(END)
@END
0;JMP
