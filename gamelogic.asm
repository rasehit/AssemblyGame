%include "deb.asm"
%include "field.asm"
global	mobsattack
global	playerattack
global	showhealth
extern	pl_x
extern	pl_y
extern	pl_max_health
extern  pl_cur_health
extern	mobs
extern	field


section	.data
en	db 27, '[30', 59, '1H', "Attacked mob's health (%): "
enl	equ $-en
hur	db  27, '[30', 59, '50H', "Health (%): "
hurl	equ $-hur

section	.text
mobsattack:
	push	rax
	push	rbx
	push	rcx
	push	rdx
	push	rdi
	push	rsi
	push	rbp
	mov	rbp, rsp
	xor	rax, rax
	xor	rbx, rbx
	mov	al, byte[pl_x]
	dec	al
	mov	bl, byte[pl_y]
	dec	bl
	XYTOINT
	mov	rdx, rax	;CURRENT
	xor	rdi, rdi
	push	2
.lp:	cmp	rdi, 35
	jg	.e
	xor	rcx, rcx
	mov	ecx, dword[mobs+rdi]
	push	rcx
	push	rdx
	call	isinradius
	add	rsp, 16
	test	rax, rax
	jnz	.hurt
	add	rdi, 6
	jmp	.lp
.hurt:	mov	ax, word[mobs+rdi+4]
	test	ax, ax
	jz	.e
	mov	ax, word[pl_cur_health]
	sub	ax, 50
	mov	word[pl_cur_health], ax
.e:	mov	rsp, rbp
	pop	rbp
	pop	rdi
	pop	rsi
	pop	rdx
	pop	rcx
	pop	rbx
	pop	rax
	ret

playerattack:
	push	rax
	push	rbx
	push	rcx
	push	rdx
	push	rdi
	push	rsi
	push	rbp
	mov	rbp, rsp
	xor	rax, rax
	xor	rbx, rbx
	mov	al, byte[pl_x]
	dec	al
	mov	bl, byte[pl_y]
	dec	bl
	XYTOINT
	mov	rdx, rax	;CURRENT
	xor	rdi, rdi
	push	2
.lp:	cmp	rdi, 35
	jg	.e
	xor	rcx, rcx
	mov	ecx, dword[mobs+rdi]
	push	rcx
	push	rdx
	call	isinradius
	add	rsp, 16
	test	rax, rax
	jnz	.hurt
	add	rdi, 6
	jmp	.lp
.hurt:	xor	rax, rax
	xor	rbx, rbx
	mov	ax, word[mobs+rdi+4]
	test	ax, ax
	jz	.e
	mov	bx, 900
	sub	ax, 110
	cmp	ax, 0
	jg	.yea
	mov	ax, word[pl_max_health]
	add	ax, 100
	mov	word[pl_max_health], ax
	mov	word[pl_cur_health], ax
	mov	word[mobs+rdi+4], 0
	mov	edx, dword[mobs+rdi]
	mov	byte[field+edx], ' '
	jmp	.e
.yea:	mov	word[mobs+rdi+4], ax
	mov	rcx, 100
	mul	rcx
	div	rbx
	push	rax
	mov	rax, 1
	mov	rdi, 1
	mov	rsi, en
	mov	rdx, enl
	syscall
	pop	rax
	PRINTINT rax
.e:	mov	rsp, rbp
	pop	rbp
	pop	rdi
	pop	rsi
	pop	rdx
	pop	rcx
	pop	rbx
	pop	rax
	ret

showhealth:
	push	rax
	push	rbx
	xor	rax, rax
	xor	rbx, rbx
	mov	ax, word[pl_cur_health]
	mov	bx, word[pl_max_health]
	mov	rcx, 100
	mul	rcx
	div	rbx
	push	rax
	mov	rax, 1
	mov	rdi, 1
	mov	rsi, hur
	mov	rdx, hurl
	syscall
	pop	rax
	PRINTINT rax
	pop	rbx
	pop	rax
	ret


isinradius:
	push	rbp
	mov	rbp, rsp
	push	rbx
	push	rcx
	push	rdx
	push	rdi
	push	rsi
	mov	rsi, qword[rbp+16]	;current
	mov	rbx, qword[rbp+24]	;base
	mov	rcx, qword[rbp+32]	;radius
	mov	rax, rcx
	mov	rdx, 200
	mul	rdx
	add	rax, rcx
	sub	rbx, rax
	add	rcx, rcx
	inc	rcx
	xor	rdx, rdx
	xor	rdi, rdi
.lp1:	cmp	rdx, rcx
	je	.e
	cmp	rsi, rbx
	jl	.e
	add	rbx, rcx
	cmp	rsi, rbx
	jng	.ok
	inc	rdx
	add	rbx, 200
	sub	rbx, rcx
	jmp	.lp1
.ok	mov	rax, 1	
	jmp	.q
.e 	mov	rax, 0
.q	pop	rsi
	pop	rdi
	pop	rdx
	pop	rcx
	pop	rbx
	mov	rsp, rbp
	pop	rbp
	ret
	
