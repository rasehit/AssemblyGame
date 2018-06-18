extern	field
extern 	mobs
global	maintainfield

section	.data

section	.text
maintainfield:
	push	rbp
	mov	rbp, rsp
	
	xor	rax, rax
	xor	rbx, rbx
	xor	rcx, rcx
	xor	rdx, rdx
.lp:	cmp	rax, 40199
	je	.q
	mov	cl, byte[field+rax]
	cmp	cl, 10
	je	.space
	cmp	cl, 'm'
	je	.mob
.m:	mov	byte[field+rbx], cl
	inc	rbx	
.cont:	inc	rax
	jmp	.lp
.mob:	mov	dword[mobs+rdx], ebx
	mov	word[mobs+rdx+4], 900
	add	rdx, 6
	jmp	.m	
.space:	jmp	.cont
.q:	mov	rsp, rbp
	pop	rbp
	ret
	
