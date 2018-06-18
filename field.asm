%macro XYTOINT 0	; | (RAX - x; RBX - y)
	push	rcx
	mov	rcx, rax
	mov	rax, rbx
	mov	rbx, rcx
	mov	rcx, 200
	dec	rax
	mul 	rcx
	add	rax, rbx
	dec	rax
	pop 	rcx
%endmacro
