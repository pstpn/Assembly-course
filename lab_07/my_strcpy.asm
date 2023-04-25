PUBLIC myStrcpy

.686
.MODEL FLAT, C
.STACK
.CODE

myStrcpy proc
	mov EDI, EDX
	mov ESI, ECX
	mov ECX, EAX
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
		ret
myStrcpy endp
END