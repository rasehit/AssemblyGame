extern	int2str

section	.data
curlen	dq 0
got1	db 27, '[', 0
got2	db 59, 0
got3	db 'H', 0
yellow	db 27, '[01', 59, '38', 59, '05', 59, '222m', 0
blue	db 27, '[01', 59, '38', 59, '05', 59, '68m', 0

player		db 1	
pl_max_health	dw 1000
pl_cur_health	dw 1000
pl_x		db 5
pl_y		db 5
pl_attack1	db 70
pl_attack2	db 200
pl_ult		dw 1000
pl_cd_a1	db 50
pl_cd_a2	db 200
pl_cd_ult	dw 750 


section	.bss 
gameobj		resb 2000
intg		resb 20

section	.text
showgameobj:	;x - RAX, b - RBX
	push	rsi
	push	rdi
	push	rdx
	push	rcx
	push	rbx
	push	rax
	cmp	rax, byte[pl_x]
	jg	.n1
	cmp	rbx, byte[pl_y]
	jg	.n1
	add	rax, 79
	cmp	rax, byte[pl_x]
	jl	.n1
	add	rbx, 29
	cmp	rbx, byte[pl_y]
	jl	.n1
	push	got1
	call	addgameobj
	xor	rax, rax
	mov	al, byte[pl_x]
	push	rax
	call	int2str
	push	intg
	call	addgameobj
	push	got2
	call	addgameobj
	xor	rax, rax
	mov	al, byte[pl_y]
	push	rax
	call	int2str
	push	intg
	call	addgameobj

	push	yellow
	call	addgamobj
	add	rsp, 8
	

addgameobj:
	mov	rax, qword[rsp+8]
	xor	rbx, rbx
	xor	rcx, rcx
	mov	rdx, qword[curlen]
.lp:	mov	cl, byte[rax+rbx]
	test	cl, cl
	je	.e
	mov	byte[gameobj+rdx+rbx], cl
	inc	rbx
	jmp	.lp
.e:	add	rdx, rbx
	mov	qword[curlen], rdx
	ret


