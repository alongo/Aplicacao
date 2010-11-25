SHELL = /bin/sh
NULLCMD = :
RUNCMD = $(SHELL)
CHDIR = cd -P
exec = exec

#### Start of system configuration section. ####

srcdir = /home/aderson/.rvm/src/ruby-1.9.2-p0
top_srcdir = $(srcdir)
hdrdir = $(srcdir)/include

CC = gcc
YACC = bison
PURIFY =
AUTOCONF = autoconf

MKFILES = Makefile
BASERUBY = ruby
TEST_RUNNABLE = yes
DOXYGEN = 

prefix = /usr/local
exec_prefix = ${prefix}
bindir = ${exec_prefix}/bin
sbindir = ${exec_prefix}/sbin
libdir = ${exec_prefix}/lib
libexecdir = ${exec_prefix}/libexec
datarootdir = ${prefix}/share
datadir = ${datarootdir}
arch = i686-linux
sitearch = 
sitedir = ${rubylibprefix}/site_ruby
ruby_version = 1.9.1

TESTUI = console
TESTS =
INSTALLDOC = all
DOCTARGETS = rdoc nodoc

EXTOUT = .ext
arch_hdrdir = $(EXTOUT)/include/$(arch)
VPATH = $(arch_hdrdir)/ruby:$(hdrdir)/ruby:$(srcdir):$(srcdir)/enc:$(srcdir)/missing

empty =
OUTFLAG = -o $(empty)
COUTFLAG = -o $(empty)
ARCH_FLAG = 
CFLAGS = ${cflags}
cflags =  ${optflags} ${debugflags} ${warnflags}
optflags = -O3
debugflags = -ggdb
warnflags = -Wextra -Wno-unused-parameter -Wno-parentheses -Wpointer-arith -Wwrite-strings -Wno-missing-field-initializers -Wno-long-long
XCFLAGS = -I. -I$(arch_hdrdir) -I$(hdrdir) -I$(srcdir) -DRUBY_EXPORT
CPPFLAGS =  $(DEFS) ${cppflags}
LDFLAGS =  $(CFLAGS) -L.  -rdynamic -Wl,-export-dynamic
EXTLDFLAGS = 
XLDFLAGS =  $(EXTLDFLAGS)
EXTLIBS = 
LIBS = -lpthread -lrt -ldl -lcrypt -lm  $(EXTLIBS)
MISSING =  ${LIBOBJDIR}strlcpy.o ${LIBOBJDIR}strlcat.o 
LDSHARED = $(CC) -shared
DLDFLAGS =  $(EXTLDFLAGS) $(ARCH_FLAG)
SOLIBS = 
MAINLIBS = 
ARCHMINIOBJS = dmydln.o
BUILTIN_ENCOBJS =  ascii.$(OBJEXT) us_ascii.$(OBJEXT) unicode.$(OBJEXT) utf_8.$(OBJEXT)
BUILTIN_TRANSSRCS =  newline.c
BUILTIN_TRANSOBJS =  newline.$(OBJEXT)

RUBY_BASE_NAME=ruby
RUBY_PROGRAM_VERSION=1.9.2
RUBY_INSTALL_NAME=$(RUBY_BASE_NAME)
RUBY_SO_NAME=$(RUBY_BASE_NAME)
EXEEXT = 
PROGRAM=$(RUBY_INSTALL_NAME)$(EXEEXT)
RUBY = $(RUBY_INSTALL_NAME)
MINIRUBY = ./miniruby$(EXEEXT) -I$(srcdir)/lib -I$(EXTOUT)/common -I./- -r$(srcdir)/ext/purelib.rb $(MINIRUBYOPT)
RUNRUBY = $(MINIRUBY) $(srcdir)/tool/runruby.rb --extout=$(EXTOUT) $(RUNRUBYOPT) --
XRUBY = $(RUNRUBY)

#### End of system configuration section. ####

MAJOR=	1
MINOR=	9
TEENY=	1

LIBRUBY_A     = lib$(RUBY_SO_NAME)-static.a
LIBRUBY_SO    = lib$(RUBY_SO_NAME).so.$(MAJOR).$(MINOR).$(TEENY)
LIBRUBY_ALIASES= lib$(RUBY_SO_NAME).so
LIBRUBY	      = $(LIBRUBY_A)
LIBRUBYARG    = $(LIBRUBYARG_STATIC)
LIBRUBYARG_STATIC = -Wl,-R -Wl,$(libdir) -L$(libdir) -l$(RUBY_SO_NAME)-static
LIBRUBYARG_SHARED = -Wl,-R -Wl,$(libdir) -L$(libdir) -l$(RUBY_SO_NAME)

THREAD_MODEL  = pthread

PREP          = miniruby$(EXEEXT)
ARCHFILE      = 
SETUP         =
EXTSTATIC     = 
SET_LC_MESSAGES = env LC_MESSAGES=C

MAKEDIRS      = /bin/mkdir -p
CP            = cp
MV            = mv
RM            = rm -f
RMDIRS        = $(top_srcdir)/tool/rmdirs
RMALL         = rm -fr
NM            = 
AR            = ar
ARFLAGS       = rcu
RANLIB        = ranlib
AS            = as
ASFLAGS       = 
IFCHANGE      = $(srcdir)/tool/ifchange
SET_LC_MESSAGES = env LC_MESSAGES=C
OBJDUMP       = objdump
OBJCOPY       = objcopy
VCS           = echo cannot
VCSUP         = $(VCS)

OBJEXT        = o
ASMEXT        = S
DLEXT         = so
MANTYPE	      = doc

INSTALLED_LIST= .installed.list

MKMAIN_CMD    = mkmain.sh

SRC_FILE      = $<
#### End of variables

all:

.DEFAULT: all

# Prevent GNU make v3 from overflowing arg limit on SysV.
.NOEXPORT:

miniruby$(EXEEXT):
		@-if test -f $@; then $(MV) -f $@ $@.old; $(RM) $@.old; fi
		$(PURIFY) $(CC) $(LDFLAGS) $(XLDFLAGS) $(MAINLIBS) $(NORMALMAINOBJ) $(MINIOBJS) $(COMMONOBJS) $(DMYEXT) $(LIBS) $(OUTFLAG)$@

$(PROGRAM):
		@$(RM) $@
		$(PURIFY) $(CC) $(LDFLAGS) $(XLDFLAGS) $(MAINLIBS) $(MAINOBJ) $(EXTOBJS) $(LIBRUBYARG) $(LIBS) $(OUTFLAG)$@

# We must `rm' the library each time this rule is invoked because "updating" a
# MAB library on Apple/NeXT (see --enable-fat-binary in configure) is not
# supported.
$(LIBRUBY_A):
		@$(RM) $@
		$(AR) $(ARFLAGS) $@ $(OBJS) $(DMYEXT)
		@-$(RANLIB) $@ 2> /dev/null || true

$(LIBRUBY_SO):
		@-$(PRE_LIBRUBY_UPDATE)
		$(LDSHARED) $(DLDFLAGS) $(OBJS) $(DLDOBJS) $(SOLIBS) $(OUTFLAG)$@
		-$(OBJCOPY) -w -L 'Init_*' -L '*_threadptr_*' $@
		@-$(MINIRUBY) -e 'ARGV.each{|link| File.delete link if File.exist? link; \
						  File.symlink "$(LIBRUBY_SO)", link}' \
				$(LIBRUBY_ALIASES) || true

fake: $(arch)-fake.rb
$(arch)-fake.rb: config.status $(srcdir)/template/fake.rb.in
		@./config.status --file=$@:$(srcdir)/template/fake.rb.in
		@chmod +x $@

Makefile:	$(srcdir)/Makefile.in $(srcdir)/enc/Makefile.in

$(MKFILES): config.status
		MAKE=$(MAKE) $(SHELL) ./config.status
		@{ \
		    echo "all:; -@rm -f conftest.mk"; \
		    echo "conftest.mk: .force; @echo AUTO_REMAKE"; \
		    echo ".force:"; \
		} > conftest.mk || exit 1; \
		$(MAKE) -f conftest.mk | grep '^AUTO_REMAKE$$' >/dev/null 2>&1 || \
		{ echo "Makefile updated, restart."; exit 1; }

uncommon.mk: $(srcdir)/common.mk
		sed 's/{\$$([^(){}]*)[^{}]*}//g' $< > $@

config.status:	$(srcdir)/configure $(srcdir)/enc/Makefile.in
	@PWD= MINIRUBY="$(MINIRUBY)"; export MINIRUBY; \
	set $(SHELL) ./config.status --recheck; \
	exec 3>&1; exit `exec 4>&1; { "$$@" 3>&- 4>&-; echo $$? 1>&4; } | fgrep -v '(cached)' 1>&3`

$(srcdir)/configure: $(srcdir)/configure.in
	$(CHDIR) $(srcdir) && exec $(AUTOCONF)

incs: id.h

# Things which should be considered:
# * with gperf v.s. without gperf
# * committers may have various versions of gperf
# * ./configure v.s. ../ruby/configure
# * GNU make v.s. HP-UX make	# HP-UX make invokes the action if lex.c and keywords has same mtime.
# * svn checkout generate a file with mtime as current time
# * ext4 and XFS has a mtime with fractional part
lex.c: defs/keywords
	@\
	if cmp -s $(srcdir)/defs/lex.c.src $?; then \
	  set -x; \
	  $(CP) $(srcdir)/lex.c.blt $@; \
	else \
	  set -x; \
	  gperf -C -p -j1 -i 1 -g -o -t -N rb_reserved_word -k1,3,$$ $? > $@.tmp && \
	  $(MV) $@.tmp $@ && \
	  $(CP) $? $(srcdir)/defs/lex.c.src && \
	  $(CP) $@ $(srcdir)/lex.c.blt; \
	fi

NAME2CTYPE_OPTIONS = -7 -c -j1 -i1 -t -C -P -T -H uniname2ctype_hash -Q uniname2ctype_pool -N uniname2ctype_p

enc/unicode/name2ctype.h: enc/unicode/name2ctype.kwd
	$(MAKEDIRS) $(@D)
	@set +e; \
	if cmp -s $(?:.kwd=.src) $?; then \
	  set -x; \
	  $(CP) $(?:.kwd=.h.blt) $@; \
	else \
	  trap '$(RM) $@-1.h $@-2.h' 0 && \
	  set -x; \
	  sed '/^#ifdef USE_UNICODE_PROPERTIES/,/^#endif/d' $? | gperf $(NAME2CTYPE_OPTIONS) > $@-1.h && \
	  gperf $(NAME2CTYPE_OPTIONS) < $? > $@-2.h && \
	  diff -DUSE_UNICODE_PROPERTIES $@-1.h $@-2.h > $@.tmp || :; \
	  $(MV) $@.tmp $@ && \
	  $(CP) $? $(?:.kwd=.src) && \
	  $(CP) $@ $(?:.kwd=.h.blt); \
	fi

.c.o:
	$(CC) $(CFLAGS) $(XCFLAGS) $(CPPFLAGS) $(COUTFLAG)$@ -c $<

.s.o:
	$(AS) $(ASFLAGS) -o $@ $<

.c.S:
	$(CC) $(CFLAGS) $(XCFLAGS) $(CPPFLAGS) $(COUTFLAG)$@ -S $<

.c.i:
	$(CPP) $(XCFLAGS) $(CPPFLAGS) $(COUTFLAG)$@ -E $< > $@

clean-local::
	@$(RM) ext/extinit.c ext/extinit.$(OBJEXT) ext/ripper/y.output

distclean-local::
	@$(RM) ext/config.cache $(RBCONFIG) Doxyfile
	@-$(RM) run.gdb
	@-$(RM) $(INSTALLED_LIST) $(arch_hdrdir)/ruby/config.h
	@-$(RMDIRS) $(arch_hdrdir)/ruby

distclean-rdoc:
	@$(RMALL) $(RDOCOUT:/=\)

clean-ext distclean-ext realclean-ext::
	@if [ -d ext ]; then \
	    cd ext; set dummy `echo "${EXTS}" | tr , ' '`; shift; \
	    test "$$#" = 0 && set .; \
	    set dummy `for dir in "$$@"; do \
	        find $$dir -name Makefile | sed 's:^\./::;s:/Makefile$$:~:' | sort | sed 's:~$$::'; \
	    done`; shift; \
	    cd ..; \
	    for dir in "$$@"; do \
	        echo $(@:-ext=)ing "$$dir"; \
	        (cd "ext/$$dir" && exec $(MAKE) $(MFLAGS) $(@:-ext=)) && \
	        case "$@" in \
	        *distclean-ext*|*realclean-ext*) \
		    $(RMDIRS) "ext/$$dir";; \
	        esac; \
	    done \
	fi

distclean-ext realclean-ext::
	@-rmdir ext 2> /dev/null || true

ext/extinit.$(OBJEXT): ext/extinit.c $(SETUP)
	$(CC) $(CFLAGS) $(XCFLAGS) $(CPPFLAGS) $(COUTFLAG)$@ -c ext/extinit.c

up::
	@$(CHDIR) "$(srcdir)" && LC_TIME=C exec $(VCSUP)

update-mspec:
	@$(CHDIR) $(srcdir); \
	if [ -d spec/mspec ]; then \
	  cd spec/mspec; \
	  echo updating mspec ...; \
	  exec git pull; \
	else \
	  echo retrieving mspec ...; \
	  exec git clone $(MSPEC_GIT_URL) spec/mspec; \
	fi

update-rubyspec: update-mspec
	@$(CHDIR) $(srcdir); \
	if [ -d spec/rubyspec ]; then \
	  cd spec/rubyspec; \
	  echo updating rubyspec ...; \
	  exec git pull; \
	else \
	  echo retrieving rubyspec ...; \
	  exec git clone $(RUBYSPEC_GIT_URL) spec/rubyspec; \
	fi

test-rubyspec:
	@if [ ! -d $(srcdir)/spec/rubyspec ]; then echo No rubyspec here.  make update-rubyspec first.; exit 1; fi
	$(RUNRUBY) $(srcdir)/spec/mspec/bin/mspec run -B $(srcdir)/spec/default.mspec $(MSPECOPT)

INSNS	= opt_sc.inc optinsn.inc optunifs.inc insns.inc insns_info.inc \
	  vmtc.inc vm.inc

$(INSNS): $(srcdir)/insns.def vm_opts.h \
	  $(srcdir)/defs/opt_operand.def $(srcdir)/defs/opt_insn_unif.def \
	  $(srcdir)/tool/instruction.rb $(srcdir)/tool/insns2vm.rb
	$(BASERUBY) -Ks $(srcdir)/tool/insns2vm.rb $(INSNS2VMOPT) $@

distclean-local::; @$(RM) GNUmakefile uncommon.mk
