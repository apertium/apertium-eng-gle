###############################################################################
## Makefile for English--Irish
###############################################################################

LANG1=eng
LANG2=gle
PREFIX1=$(LANG1)-$(LANG2)
PREFIX2=$(LANG2)-$(LANG1)

BASENAME=apertium-$(PREFIX1)

TARGETS_COMMON =		\
	$(PREFIX1).automorf.bin	\
	$(PREFIX1).prob		\
	$(PREFIX1).autobil.bin	\
	$(PREFIX1).autogen.bin	\
	$(PREFIX1).autopgen.bin	\
	$(PREFIX1).t1x.bin	\
	$(PREFIX1).t2x.bin	\
	$(PREFIX1).t3x.bin	\
	$(PREFIX2).automorf.bin	\
	$(PREFIX2).autobil.bin	\
	$(PREFIX2).autogen.bin	\
	$(PREFIX2).autopgen.bin	\
	$(PREFIX2).t1x.bin	\
	$(PREFIX2).t2x.bin	\
	$(PREFIX2).t3x.bin

# This include defines goals for install-modes, .deps/.d, autobil.prefixes and .mode files:
@ap_include@

###############################################################################
## Monolingual transducers
###############################################################################

.deps/$(LANG1).metadix: $(BASENAME).$(LANG1).metadix .deps/.d
	xsltproc --stringparam alt en_GB alt.xsl $(BASENAME).$(LANG1).metadix >$@

.deps/$(LANG1).dix: .deps/$(LANG1).metadix
	xsltproc buscaPar.xsl .deps/$(LANG1).metadix | uniq >$$$$tmp1 && \
	xsltproc $$$$tmp1 .deps/$(LANG1).metadix > $@ && rm $$$$tmp1

$(PREFIX1).automorf.bin: .deps/$(LANG1).dix
	apertium-validate-dictionary .deps/$(LANG1).dix
	apertium-validate-acx $(BASENAME).$(LANG1).acx
	lt-comp lr .deps/$(LANG1).dix $@ $(BASENAME).$(LANG1).acx

$(PREFIX2).autogen.bin: .deps/$(LANG1).dix
	apertium-validate-dictionary .deps/$(LANG1).dix
	lt-comp rl .deps/$(LANG1).dix $@

$(PREFIX2).automorf.bin: $(BASENAME).$(LANG2).dix
	apertium-validate-dictionary $(BASENAME).$(LANG2).dix
	apertium-validate-acx $(BASENAME).$(LANG2).acx
	lt-comp lr $(BASENAME).$(LANG2).dix $@ $(BASENAME).$(LANG2).acx

$(PREFIX1).autogen.bin: $(BASENAME).$(LANG2).dix
	apertium-validate-dictionary $(BASENAME).$(LANG2).dix
	lt-comp rl $(BASENAME).$(LANG2).dix $@


###############################################################################
## Lexical selection rules
###############################################################################

$(PREFIX1).autolex.bin: $(BASENAME).$(PREFIX1).lrx
	lrx-comp $< $@

$(PREFIX2).autolex.bin: $(BASENAME).$(PREFIX2).lrx
	lrx-comp $< $@


###############################################################################
## Structural transfer rules
###############################################################################


$(PREFIX1).t1x.bin: $(BASENAME).$(PREFIX1).t1x
	apertium-validate-transfer $<
	apertium-preprocess-transfer $< $@

$(PREFIX1).t2x.bin: $(BASENAME).$(PREFIX1).t2x
	apertium-validate-interchunk $<
	apertium-preprocess-transfer $< $@

$(PREFIX1).t3x.bin: $(BASENAME).$(PREFIX1).t3x
	apertium-validate-postchunk $<
	apertium-preprocess-transfer $< $@


$(PREFIX2).t1x.bin: $(BASENAME).$(PREFIX2).t1x
	apertium-validate-transfer $<
	apertium-preprocess-transfer $< $@

$(PREFIX2).t2x.bin: $(BASENAME).$(PREFIX2).t2x
	apertium-validate-interchunk $<
	apertium-preprocess-transfer $< $@

$(PREFIX2).t3x.bin: $(BASENAME).$(PREFIX2).t3x
	apertium-validate-postchunk $<
	apertium-preprocess-transfer $< $@

###############################################################################
## Postgeneration dictionaries
###############################################################################

$(PREFIX1).autopgen.bin: $(AP_SRC2)/$(LANG2).autopgen.bin
	cp $< $@

$(PREFIX2).autopgen.bin: $(AP_SRC1)/$(LANG1).autopgen.bin
	cp $< $@

###############################################################################
## Distribution
###############################################################################

EXTRA_DIST=					\
		$(BASENAME).$(PREFIX1).dix	\
		$(BASENAME).$(PREFIX1).t1x	\
		$(BASENAME).$(PREFIX1).t2x	\
		$(BASENAME).$(PREFIX1).t3x	\
		$(BASENAME).$(PREFIX2).t1x	\
		$(BASENAME).$(PREFIX2).t2x	\
		$(BASENAME).$(PREFIX2).t3x	\
		$(BASENAME).$(LANG1).metadix	\
		$(BASENAME).$(LANG2).dix	\
		$(PREFIX1).prob			\
		$(BASENAME).$(LANG1).tsx	\
		$(BASENAME).$(LANG2).tsx	\
		$(BASENAME).post-$(LANG1).dix	\
		$(BASENAME).post-$(LANG2).dix	\
		buscaPar.xls principal.xsl alt.xsl	\
		$(BASENAME).$(LANG1).acx	\
		$(BASENAME).$(LANG2).acx	\
		modes.xml

###############################################################################
## Installation
###############################################################################

apertium_eng_gledir=$(prefix)/share/apertium/$(BASENAME)/

# Files which should be installed to $(prefix)/share/apertium/$(BASENAME)/:
apertium_eng_gle_DATA=	\
	$(TARGETS_COMMON)				\
	$(BASENAME).$(PREFIX1).t1x			\
	$(BASENAME).$(PREFIX1).t2x			\
	$(BASENAME).$(PREFIX1).t3x			\
	$(BASENAME).$(PREFIX2).t1x			\
	$(BASENAME).$(PREFIX2).t2x			\
	$(BASENAME).$(PREFIX2).t3x


# All modes are created by the same goal, listing several will just give problems with make -j2
noinst_DATA=modes/$(PREFIX1).mode \
	.deps/$(LANG1).automorf.bin \
	.deps/$(LANG2).automorf.bin

install-data-local: install-modes

###############################################################################
## Cleanup
###############################################################################

CLEANFILES = $(TARGETS_COMMON)
clean-local:
	-rm -rf .deps modes

###############################################################################
## Test
###############################################################################

test: all
	echo "house" | apertium -d . -f line eng-gle | tee .test-mt
	@echo "house" > .test-ref
	@diff .test-ref .test-mt
	echo "house" | apertium -d . -f line gle-eng | tee .test-mt
	@echo "house" > .test-ref
	@diff .test-ref .test-mt
	@rm .test-ref .test-mt
