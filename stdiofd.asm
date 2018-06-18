%define ICANON		2
%define ECHO		8
%define TCGETS		21505
%define TCPUTS		21506

global  setcan
global	setnoncan

section	.bss
stty	resb 12
slflag	resb 4
srest	resb 44

tty	resb 12
lflag	resb 4
brest	resb 44

section	.text
setnoncan:	nop
	push	stty
	call	tcgetattr
	push	tty
	call	tcgetattr
	and	dword[lflag], (~ICANON)
	and	dword[lflag], (~ECHO)
	call	tcsetattr
	add	rsp, 16
	ret

setcan:
	push	stty
	call	tcsetattr
	add	rsp, 8
	ret

tcgetattr:
	mov	rdx, qword[rsp+8]
	push	rax
	push	rbx
	push	rcx
	push	rdi
	push	rsi
	mov	rax, 16		;ioctl system call
	mov	rdi, 0
	mov	rsi, TCGETS
	syscall
	pop	rsi
	pop	rdi
	pop	rcx
	pop	rbx
	pop	rax
	ret

tcsetattr:
	mov	rdx, qword[rsp+8]
	push	rax
	push	rbx
	push	rcx
	push	rdi
	push	rsi
	mov	rax, 16		;ioctl system call
	mov	rdi, 0
	mov	rsi, TCPUTS
	syscall
	pop	rsi
	pop	rdi
	pop	rcx
	pop	rbx
	pop	rax
	ret
	
		
