DC=dmd
DFLAGS=-w
LDFLAGS=
LIBS=
SRCDIR=./src/
SRCFILES=dcalc.d options.d operations.d
OBJFILES=$(SRCFILES:.d=.o)
SRC=$(patsubst %,$(SRCDIR)%,$(SRCFILES))
OBJ=$(SRC:.d=.o)
UNITTEST_OBJ=$(OBJ:.o=.unittest.o)
OUT=$(SRCDIR)calc
UNITTEST_OUT=$(OUT).unittest
DFLAGS += -I$(SRCDIR)

ifeq ($(PROFILE),1)
	DFLAGS += -g -profile
	NODEBUG=x
endif
ifeq ($(RELEASE),1)
	DFLAGS += -g -O -release
	NODEBUG=x
endif
ifeq ($(DEBUG),1)
	NODEBUG=
endif
ifneq ($(NODEBUG),x)
	DFLAGS += -gc -gx -gs -debug
endif

all: build

.PHONY: dcompiler
dcompiler:
	@( if ! which $(DC) > /dev/null ; then \
		echo "Error: Cannot find compiler for D (looking for '$(DC)')" >&2 ; \
		exit 1 ; \
	fi )

.PHONY: unittest
unittest: clean_unittests $(UNITTEST_OUT)
	./$(UNITTEST_OUT)

$(UNITTEST_OUT): $(UNITTEST_OBJ)
	$(DC) $(DFLAGS) $(LDFLAGS) -unittest -of$@ $(UNITTEST_OBJ) $(LIBS)

%.unittest.o: %.d
	$(DC) $(DFLAGS) -unittest -of$@ -c $<

.PHONY: build
build: $(OUT)

$(OUT): $(OBJ)
	$(DC) $(DFLAGS) $(LDFLAGS) -of$@ $(OBJ) $(LIBS)

%.o: %.d
	$(DC) $(DFLAGS) -of$@ -c $<

.PHONY: clean_unittests
clean_unittests:
	rm -f $(UNITTEST_OBJ) $(UNITTEST_OUT)

.PHONY: clean
clean: clean_unittests
	rm -f *~ $(OBJ) $(OUT)
