VERSION=0.0.1
LANG1=en
LANG2=ga
PREFIX1=$(LANG1)-$(LANG2)
PREFIX2=$(LANG2)-$(LANG1)

BASENAME=apertium-en-ga

TARGETS_COMMON = $(PREFIX1).automorf.bin $(PREFIX2).automorf.bin \
	$(PREFIX1).autopgen.bin $(PREFIX2).autopgen.bin \
	$(PREFIX1).autobil.bin $(PREFIX2).autobil.bin \
	$(PREFIX1).autogen.bin $(PREFIX2).autogen.bin \
	$(PREFIX1).t1x.bin $(PREFIX2).t1x.bin \
	$(PREFIX1).t2x.bin $(PREFIX2).t2x.bin \
	$(PREFIX1).t3x.bin $(PREFIX2).t3x.bin \
	modes

TARGETS = $(TARGETS_COMMON)

.deps/$(LANG1).metadix: $(BASENAME).$(LANG1).metadix
	if [ ! -d .deps ]; then mkdir .deps; fi
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

$(PREFIX1).t1x.bin: $(BASENAME).$(PREFIX1).t1x
	apertium-validate-transfer $(BASENAME).$(PREFIX1).t1x
	apertium-preprocess-transfer $(BASENAME).$(PREFIX1).t1x $@

$(PREFIX2).t1x.bin: $(BASENAME).$(PREFIX2).t1x
	apertium-validate-transfer $(BASENAME).$(PREFIX2).t1x
	apertium-preprocess-transfer $(BASENAME).$(PREFIX2).t1x $@

$(PREFIX1).t2x.bin: $(BASENAME).$(PREFIX1).t2x
	apertium-validate-interchunk $(BASENAME).$(PREFIX1).t2x
	apertium-preprocess-transfer $(BASENAME).$(PREFIX1).t2x $@

$(PREFIX2).t2x.bin: $(BASENAME).$(PREFIX2).t2x
	apertium-validate-interchunk $(BASENAME).$(PREFIX2).t2x
	apertium-preprocess-transfer $(BASENAME).$(PREFIX2).t2x $@

$(PREFIX1).t3x.bin: $(BASENAME).$(PREFIX1).t3x
	apertium-validate-postchunk $(BASENAME).$(PREFIX1).t3x
	apertium-preprocess-transfer $(BASENAME).$(PREFIX1).t3x $@

$(PREFIX2).t3x.bin: $(BASENAME).$(PREFIX2).t3x
	apertium-validate-postchunk $(BASENAME).$(PREFIX2).t3x
	apertium-preprocess-transfer $(BASENAME).$(PREFIX2).t3x $@

$(PREFIX1).autobil.bin: $(BASENAME).$(PREFIX1).dix
	apertium-validate-dictionary $(BASENAME).$(PREFIX1).dix
	lt-comp lr $(BASENAME).$(PREFIX1).dix $@

$(PREFIX2).autobil.bin: $(BASENAME).$(PREFIX1).dix
	apertium-validate-dictionary $(BASENAME).$(PREFIX1).dix
	lt-comp lr $(BASENAME).$(PREFIX1).dix $@

$(PREFIX1).autopgen.bin: $(BASENAME).post-$(LANG1).dix
	apertium-validate-dictionary $(BASENAME).post-$(LANG1).dix
	lt-comp lr $(BASENAME).post-$(LANG1).dix $@

$(PREFIX2).autopgen.bin: $(BASENAME).post-$(LANG2).dix
	apertium-validate-dictionary $(BASENAME).post-$(LANG2).dix
	lt-comp lr $(BASENAME).post-$(LANG2).dix $@

EXTRA_DIST=$(BASENAME).post-$(LANG1).dix $(BASENAME).post-$(LANG2).dix \
	$(BASENAME).$(LANG1).tsx \
	$(BASENAME).$(LANG2).tsx \
	$(PREFIX1).prob $(PREFIX2).prob \
	$(BASENAME).$(LANG1).metadix \
	$(BASENAME).$(LANG2).dix \
	buscaPar.xsl principal.xsl alt.xsl \
	$(BASENAME).$(PREFIX1).t1x $(BASENAME).$(PREFIX1).t2x \
	$(BASENAME).$(PREFIX1).t3x $(BASENAME).$(PREFIX2).t1x \
	$(BASENAME).$(PREFIX2).t2x $(BASENAME).$(PREFIX2).t3x \
	$(BASENAME).$(LANG1).acx $(BASENAME).$(LANG2).acx \
	modes.xml

clean-dicts:
	if [ -d .deps ]; then rm .deps/*; fi

apertium_en_ga_DATA=$(PREFIX1).automorf.bin $(PREFIX2).automorf.bin \
		$(PREFIX1).autobil.bin $(PREFIX2).autobil.bin \
		$(PREFIX1).autogen.bin $(PREFIX2).autogen.bin \
		$(PREFIX1).autopgen.bin $(PREFIX2).autopgen.bin \
		$(PREFIX1).prob $(PREFIX2).prob \
		$(PREFIX1).t1x.bin $(PREFIX2).t1x.bin \
		$(PREFIX1).t2x.bin $(PREFIX2).t2x.bin \
		$(PREFIX1).t3x.bin $(PREFIX2).t3x.bin \
		$(PREFIX1).mode $(PREFIX2).mode 

apertium_en_gadir=$(prefix)/share/apertium/apertium-$(PREFIX1)/
apertium_en_ga_modesdir=$(prefix)/share/apertium/modes/

$(PREFIX1).mode: modes.xml
	apertium-gen-modes modes.xml

$(PREFIX2).mode: modes.xml
	apertium-gen-modes modes.xml

modes: modes.xml
	apertium-gen-modes modes.xml

install-data-local:
	apertium-gen-modes modes.xml apertium-$(PREFIX1)
	$(INSTALL_DATA) $(PREFIX1).mode $(apertium_en_ga_modesdir)
	$(INSTALL_DATA) $(PREFIX2).mode $(apertium_en_ga_modesdir)
	$(INSTALL_DATA) $(BASENAME).$(PREFIX1).t1x $(BASENAME).$(PREFIX1).t2x $(apertium_en_gadir)
	$(INSTALL_DATA) $(BASENAME).$(PREFIX1).t3x $(BASENAME).$(PREFIX2).t1x $(apertium_en_gadir)
	$(INSTALL_DATA) $(BASENAME).$(PREFIX2).t2x $(BASENAME).$(PREFIX2).t3x $(apertium_en_gadir)

CLEANFILES = -rf $(TARGETS) modes

