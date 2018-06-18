%include "field.asm"

extern 	camera
extern	field
extern	pl_x
extern	pl_y
global	drawfield

section	.data
clr 	db 27, '[2J', 27, '[1', 59, '1H'
clrl	equ $-clr

section	.text
;Arguments
;	x in RAX, y in RBX
;Return
;	none
drawfield:
	nop
	push	rbp
	mov	rbp, rsp
	push	rax
	push	rbx
	XYTOINT		 	;rax - number of first point
	xor	rbx, rbx	;temporary place
	xor	rcx, rcx	;outer counter
	xor	rdx, rdx	;inner couner
	xor	rdi, rdi	;camera counter
.lp1:	cmp 	rcx, 29
	je	.qlp1
	xor	rdx, rdx
.lp2:	cmp	rdx, 69
	je	.qlp2
	mov	bl, byte[field+rax]
	mov	[camera+rdi], bl
	inc	rax
	inc	rdi
	inc	rdx
	jmp	.lp2
.qlp2:	inc	rcx
	mov	byte[camera+rdi], 10
	inc	rdi
	add	rax, 131
	jmp	.lp1
.qlp1:	jmp	.draw
.draw:	pop	rbx
	pop	rax
	mov	rcx, rax
	mov	rdx, rbx
	push	rax
	push	rbx
	push	rax
	push	rbx
	xor	rax, rax
	xor	rbx, rbx
	mov	al, byte[pl_x]
	mov	bl, byte[pl_y]
	sub	al, cl
	sub	bl, dl
	mov	rdi, rax
	mov	rax, rbx
	mov	rbx, rdi
	mov	rdi, 70
	dec	rax
	mul	rdi
	add	rax, rbx
	dec	rax
	cmp	rax, 0
	jng	.pe
	cmp	rax, 2399
	jnl	.pe
	mov	byte[camera+rax], 'G'
.pe:	push	rcx
	push	rdx
	push	rdi
	push	rsi
	mov	rax, 1
	mov	rdi, 1
	mov	rsi, clr
	mov	rdx, clrl
	syscall
	mov	rax, 1
	mov	rdi, 1
	mov	rsi, camera
	mov	rdx, 2400
	syscall
	pop	rsi
	pop	rdi
	pop	rdx
	pop	rcx
	pop	rbx
	pop	rax
.ex:	pop	rbx
	pop	rax
	mov	rsp, rbp
	pop	rbp
	ret
