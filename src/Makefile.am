NULL =

AM_CPPFLAGS = \
	-I$(top_srcdir) \
	$(NULL)

lib_LTLIBRARIES = \
	libgsm0710.la
	$(NULL)

libgsm0710_la_SOURCES = \
	gsm0710.c \
	gsm0710.h \
	$(NULL)

gsm0710includedir = $(includedir)/gsm0710-1.0/gsm/

gsm0710include_HEADERS = \
	gsm0710.h \
	$(NULL)

libgsm0710_la_LIBADD = \
	$(NULL)

vapidir = $(datadir)/vala/vapi

dist_vapi_DATA = \
	gsm0710-1.0.vapi \
	$(NULL)

EXTRA_DIST = gsm0710-1.0.vapi
