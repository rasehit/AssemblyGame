global	_start
global	poll
global	sleep

section	.data
sec	dq 0
nsec	dq 0
fd	dd 0 	;stdin
eve	dw 1	;POLLIN
rev	dw 0
sym	db 0	

section	.text
poll:	nop
	push	rbx
	push	rcx
	push	rdx
	push	rdi
	push	rsi
	mov	rax, 7
	mov	rdi, fd
	mov	rsi, 1
	mov	rdx, 0
	syscall
	test	rax, rax
	jz	.e
	mov	rax, 0
	mov	rdi, 0
	mov	rsi, sym
	mov	rdx, 1
	syscall
	xor	rax, rax
	mov	al, byte[sym]
.e:	pop	rsi
	pop	rdi
	pop	rdx
	pop	rcx
	pop	rbx
	ret	
	
sleep:
	mov	rax, qword[rsp+8]
	xor	rdx, rdx
	mov	rbx, 1000000
	mov	rcx, 1000
	div	rbx
	mov	qword[sec], rax
	mov	rax, rdx
	mul	rcx
	mov	qword[nsec], rax
	mov	rax, 35
	mov	rdi, sec
	mov	rsi, 0
	syscall
	ret
