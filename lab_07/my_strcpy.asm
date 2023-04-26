PUBLIC myStrcpy

.686
.MODEL FLAT, C
.STACK
.CODE

myStrcpy proc dst:dword, src:dword, len:dword
	pushf

	mov ESI, src
	mov EDI, dst
	mov ECX, len
	mov byte ptr [ESI + ECX], 0
	inc ECX

	cmp EDI, ESI
	je exit
	jl beg_cpy

	add EDI, ECX
	add ESI, ECX
	dec EDI
	dec ESI

	std

	beg_cpy:
		rep movsb
		cld

	exit:
		popf
		ret
myStrcpy endp
END