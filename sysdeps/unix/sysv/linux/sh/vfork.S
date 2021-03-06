/* Copyright (C) 2004-2014 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, see
   <http://www.gnu.org/licenses/>.  */

#include <sysdep.h>
#define _ERRNO_H	1
#include <bits/errno.h>
#include <tcb-offsets.h>

/* Clone the calling process, but without copying the whole address space.
   The calling process is suspended until the new process exits or is
   replaced by a call to `execve'.  Return -1 for errors, 0 to the new process,
   and the process ID of the new process to the old process.  */

ENTRY (__libc_vfork)
	/* Save the PID value.  */
	stc	gbr, r2
	mov.w	.L2, r0
	mov.l	@(r0,r2), r4
	neg	r4, r1
	tst	r1, r1
	bf	1f
	mov	#1, r1
	rotr	r1
1:
	mov.l	r1, @(r0,r2)

	mov.w	.L1, r3
	trapa	#0x10
	mov     r0, r1

	/* Restore the old PID value in the parent.  */
	tst	r0, r0
	bt.s	2f
	 stc	gbr, r2
	mov.w	.L2, r0
	mov.l	r4, @(r0,r2)
	mov	r1, r0
2:
	mov	#-12, r2
	shad	r2, r1
	not	r1, r1			// r1=0 means r0 = -1 to -4095
	tst	r1, r1			// i.e. error in linux
	bf	.Lpseudo_end
	SYSCALL_ERROR_HANDLER
.Lpseudo_end:
	rts
	 nop
.L1:
	.word	__NR_vfork
.L2:
	.word	PID - TLS_PRE_TCB_SIZE
	.align	2
PSEUDO_END (__libc_vfork)

#if !NOT_IN_libc
weak_alias (__libc_vfork, vfork)
strong_alias (__libc_vfork, __vfork)
libc_hidden_def (__vfork)
#endif
