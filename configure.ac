AC_PREREQ(2.52)

AC_INIT([Apertium English-Irish], [0.0.1], [jimregan@users.sourceforge.net], [apertium-eng-gle], [http://wiki.apertium.org/wiki/Apertium-eng-gle])
AM_INIT_AUTOMAKE
AC_PROG_AWK

PKG_CHECK_MODULES(APERTIUM, apertium >= 3.6.1)
PKG_CHECK_MODULES(LTTOOLBOX, lttoolbox >= 3.5.1)

ALTXSL="alt.xsl";
AC_SUBST(ALTXSL)

AC_PATH_PROGS(ZCAT, [gzcat zcat], [false])
AS_IF([test x$ZCAT = xfalse], [AC_MSG_ERROR([You don't have zcat nor gzcat installed])])

m4_ifdef([AP_CHECK_LING],[],[AC_MSG_ERROR([AP_CHECK_LING not defined, is apertium.m4 in ACLOCAL_PATH? See: http://wiki.apertium.org/wiki/Installation_troubleshooting])])


#AP_CHECK_LING([1], [apertium-eng])

#AP_CHECK_LING([2], [apertium-gle])

AP_MKINCLUDE

AC_OUTPUT([Makefile])
