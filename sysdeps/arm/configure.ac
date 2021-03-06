GLIBC_PROVIDES dnl See aclocal.m4 in the top level source directory.
# Local configure fragment for sysdeps/arm.

dnl It is always possible to access static and hidden symbols in an
dnl position independent way.
dnl NOTE: This feature was added by the GCC TLS patches.  We should test for
dnl it.  Until we do, don't define it.
#AC_DEFINE(PI_STATIC_AND_HIDDEN)

# We check to see if the compiler and flags are
# selecting the hard-float ABI and if they are then
# we set libc_cv_arm_pcs_vfp to yes which causes
# HAVE_ARM_PCS_VFP to be defined in config.h and
# in include/libc-symbols.h and thus available to
# shlib-versions to select the appropriate name for
# the dynamic linker via %ifdef.
AC_CACHE_CHECK([whether the compiler is using the ARM hard-float ABI],
  [libc_cv_arm_pcs_vfp],
  [AC_EGREP_CPP(yes,[#ifdef __ARM_PCS_VFP
                      yes
                     #endif
  ], libc_cv_arm_pcs_vfp=yes, libc_cv_arm_pcs_vfp=no)])
if test $libc_cv_arm_pcs_vfp = yes; then
  AC_DEFINE(HAVE_ARM_PCS_VFP)
  LIBC_CONFIG_VAR([default-abi], [hard])
else
  LIBC_CONFIG_VAR([default-abi], [soft])
fi

AC_CACHE_CHECK([whether the build tools support the GNU descriptor TLS scheme],
  [libc_cv_arm_tls_desc],
  [old_CFLAGS="$CFLAGS"
  CFLAGS="$CFLAGS -mtls-dialect=gnu2"
  AC_COMPILE_IFELSE([AC_LANG_PROGRAM([asm (".word\tfoo(tlsdesc)");], [])],
    [libc_cv_arm_tls_desc=yes], [libc_cv_arm_tls_desc=no])
  CFLAGS="$old_CFLAGS"])
if test $libc_cv_arm_tls_desc = yes; then
  LIBC_CONFIG_VAR([have-arm-tls-desc], [yes])
else
  LIBC_CONFIG_VAR([have-arm-tls-desc], [no])
fi
