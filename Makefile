PREFIX=/usr/local
XDG_CONFIG_DIR=/usr/local/etc/xdg/wmfs
MANPREFIX=/usr/local/man

CFLAGS=-I/usr/include/freetype2   -DHAVE_XINERAMA -DHAVE_XRANDR -DHAVE_IMLIB2
LDFLAGS=-lX11 -lXft -lfreetype -lXinerama -lXrandr -lImlib2   -lpthread

PROG=wmfs
MAN=wmfs.1

# wmfs version
VERSION= 201011

SRCS= \
src/barwin.c \
src/client.c \
src/config.c \
src/draw.c \
src/event.c \
src/ewmh.c \
src/frame.c \
src/getinfo.c \
src/infobar.c \
src/init.c \
src/launcher.c \
src/layout.c \
src/menu.c \
src/mouse.c \
src/parse/api.c \
src/parse/parse.c \
src/screen.c \
src/status.c \
src/systray.c \
src/tag.c \
src/util.c \
src/viwmfs.c \
src/wmfs.c

# flags
CFLAGS+= -DXDG_CONFIG_DIR=\"${XDG_CONFIG_DIR}\"
CFLAGS+= -DWMFS_VERSION=\"${VERSION}\"

OBJS= ${SRCS:.c=.o}

all: ${PROG} ${MAN}.gz

${PROG}: ${OBJS} src/structs.h src/wmfs.h src/parse/parse.h
	${CC} -o $@ ${OBJS} ${LDFLAGS}

${MAN}.gz: ${MAN}
	gzip -cn -9 ${MAN} > $@

.c.o:
	${CC} -c ${CFLAGS} $< -o $@

clean:
	rm -f ${OBJS} wmfs ${MAN}.gz

install: all
	@echo installing executable file to ${DESTDIR}${PREFIX}/bin
	mkdir -p ${DESTDIR}${PREFIX}/bin
	install ${PROG} ${DESTDIR}${PREFIX}/bin
	@echo installing manual page to ${DESTDIR}${MANPREFIX}/man1
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	install -m 644 ${MAN}.gz ${DESTDIR}${MANPREFIX}/man1/
	@echo installing xsession file to ${DESTDIR}${PREFIX}/share/xsessions
	mkdir -p ${DESTDIR}${PREFIX}/share/xsessions
	install -m 644 wmfs.desktop ${DESTDIR}${PREFIX}/share/xsessions/
	@echo installing default config file to ${DESTDIR}${XDG_CONFIG_DIR}
	mkdir -p ${DESTDIR}${XDG_CONFIG_DIR}
	install -m 444 wmfsrc ${DESTDIR}${XDG_CONFIG_DIR}

uninstall:
	@echo removing executable file from ${DESTDIR}${PREFIX}/bin
	rm -f ${DESTDIR}${PREFIX}/bin/wmfs
	@echo removing manual page from ${DESTDIR}${MANPREFIX}/man1
	rm -f ${DESTDIR}${MANPREFIX}/man1/wmfs.1.gz
	@echo removing xsession file from ${DESTDIR}${PREFIX}/share/xsessions
	rm -f ${DESTDIR}${PREFIX}/share/xsessions/wmfs.desktop
	@echo removing config file from ${DESTDIR}${XDG_CONFIG_DIR}
	rm -f ${DESTDIR}${XDG_CONFIG_DIR}/wmfsrc



.PHONY: all clean install uninstall

