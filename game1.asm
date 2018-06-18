;-----------------------------------include files----------------------------
%include "deb.asm"		;debug tools	
;asm2_64.o			: debugging
;readfromfile.o			: for file reading	
;maintainfield.o		: for game field initializing
;stdiofd.o			: for non-canonical xterm mode
;camera.o 			: for camera updating
;block.o			; for non-blocking xterm input and sleep proc

;-----------------------------------dependencies-----------------------------
global _start			; entry point
global	field			; game field for external files
global	camera			; camera buffer for external files
global	pl_x			; linking for other files
global	pl_y			;
global	mobs
global	pl_cur_health
global	pl_max_health
extern 	readfromfile		; procedure for initializating field
extern	maintainfield		; procedure for maintaining field
extern	setnoncan		; noncanonical xterm mode
extern	setcan			; canonical xterm mode
extern	drawfield		; setting up camera with background
extern	poll			; non-blocking xterm input
extern	sleep			; stop program
extern 	mobsattack
extern	playerattack
extern	showhealth
;--------------------------------------nSS----------------------------------
section	.bss
field 	resb 40200		;field buffer
camera	resb 2400		;camera buffer
mobs	resb 36

;--------------------------------------DATA----------------------------------
section	.data
player		db 1	
pl_max_health	dw 1000
pl_cur_health	dw 1000
pl_x		db 10
pl_y		db 10
pl_attack1	dw 70
pl_attack2	dw 200
pl_ult		dw 1000
pl_cd_a1	dw 50
pl_cd_a2	dw 200
pl_cd_ult	dw 750 

mob_time	db 0
pl_time		db 0

;--------------------------------------TEXT----------------------------------
section	.text
_start:	nop	
	push	qword[rsp+16]	; adress of field file
	call	readfromfile	; opens file and set field buffer from file
	call	maintainfield	; sets up field for game
	call	setnoncan	; sets non-canonical xterm mode
	mov	rax, 1		; initial
	mov	rbx, 1		; camera position
	call	gameproc	; main procedurea
	call	setcan		; returns xterm in normal mode
	mov	rax, 60		; exiting
	mov	rdi, 0
	syscall


gameproc:
.lp:	push	rax
	push	rbx
	push	10000
	call	sleep
	add	rsp, 8
	xor	rdx, rdx
	mov	dl, byte[mob_time]
	cmp	dl, 100
	jne	.z1
	call	mobsattack
	call	showhealth
	xor	dl, dl
.z1:	inc	dl
	mov	byte[mob_time], dl
	mov	dl, byte[pl_time]
	cmp	dl, 100
	jl	.z2
	mov	dl, 99
.z2:	inc	dl
	mov	byte[pl_time], dl
	call	poll
	mov	rcx, rax
	pop	rbx
	pop	rax
	test	cl, cl
	je	.lp
	cmp	cl, 100		;'d'
	je	.p_r
	cmp	cl, 97		;'a'
	je	.p_l
	cmp	cl, 115		;'s'
	je	.p_d
	cmp	cl, 119		;'w'
	je	.p_up
	cmp	cl, 27		; esc
	je	.exit
	cmp	cl, 56		; '8'
	je	.c_up
	cmp	cl, 50		; '2'
	je	.c_d		
	cmp	cl, 54		; '6'
	je	.c_r
	cmp	cl, 52		; '4'
	je	.c_l		
;	cmp	cl, 32		; space
;	je	.space
	cmp	cl, 113		; 'q'
	je	.q_pr	
;	cmp	cl, 101		; 'e'
;	je	
	jmp	.lp
.q_pr:	mov	dl, byte[pl_time]
	cmp	dl, 99
	jl	.lp
	call 	playerattack
	mov	byte[pl_time], 0
	jmp	.lp
.c_d:	cmp	rbx, 171
	jg	.lp
	inc	rbx
	call	drawfield
	jmp	.lp
.c_up:	cmp	rbx, 2
	jl	.lp
	dec	rbx
	call	drawfield
	jmp	.lp
.c_r:	cmp	rax, 131
	jg	.lp
	inc	rax
	call	drawfield
	jmp	.lp
.c_l:	cmp	rax, 2
	jl	.lp
	dec	rax
	call	drawfield
	jmp	.lp
.p_up:	mov	cl, byte[pl_x]
	mov	dl, byte[pl_y]
	push	rdx
	push	rcx
	call	xytoint
	add	rsp, 16
	mov	cl, byte[field+rcx-200]
	cmp	cl, ' '
	jne	.lp
	mov	cl, byte[pl_y]	
	dec	cl
	mov	byte[pl_y], cl
	jmp	.centr
.p_d:	mov	cl, byte[pl_x]
	mov	dl, byte[pl_y]
	push	rdx
	push	rcx
	call	xytoint
	add	rsp, 16
	mov	cl, byte[field+rcx+200]
	cmp	cl, ' '
	jne	.lp
	mov	cl, byte[pl_y]	
	inc	cl
	mov	byte[pl_y], cl
	jmp 	.centr
.p_r:	mov	cl, byte[pl_x]
	mov	dl, byte[pl_y]
	push	rdx
	push	rcx
	call	xytoint
	add	rsp, 16
	mov	cl, byte[field+rcx+1]
	cmp	cl, ' '
	jne	.lp
	mov	cl, byte[pl_x]
	inc	cl
	mov	byte[pl_x], cl
	jmp	.centr
.p_l:	mov	cl, byte[pl_x]
	mov	dl, byte[pl_y]
	push	rdx
	push	rcx
	call	xytoint
	add	rsp, 16
	mov	cl, byte[field+rcx-1]
	cmp	cl, ' '
	jne	.lp
	mov	cl, byte[pl_x]
	dec	cl
	mov	byte[pl_x], cl
	jmp	.centr
.centr:	mov	cl, byte[pl_x]
	mov	dl, byte[pl_y]
	cmp	cl, 36
	jb	.x_0
	cmp	cl, 165
	ja	.x_131
.nm:	cmp	dl, 16
	jb	.y_0
	cmp	dl, 185
	ja	.y_171
	jmp	.f 
.x_0:	mov	cl, 36
	jmp	.nm
.x_131:	mov	cl, 165
	jmp	.nm
.y_0:	mov	dl, 16
	jmp	.f
.y_171:	mov	dl, 185
	jmp	.f
.f:	sub	cl, 34
	sub	dl, 14
	mov	al, cl
	mov	bl, dl
	call	drawfield
	call	showhealth
	jmp	.lp
	
.exit:	ret

xytoint:
	push	rax
	push	rbx
	mov	rbx, qword[rsp+24]	;x
	mov	rax, qword[rsp+32]	;y
	mov	rcx, 200
	dec	rax
	dec	rax
	mul	rcx
	add	rax, rbx
	dec	rax
	dec	rax
	mov	rcx, rax
	pop	rbx
	pop	rax
	ret	
