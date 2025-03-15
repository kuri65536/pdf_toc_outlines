
src:=src/pdf_toc_outlines.nim \
     src/pdf_toc_outlines/app_common.nim \
     src/pdf_toc_outlines/app_extract.nim \
     src/pdf_toc_outlines/app_levels.nim \
     src/pdf_toc_outlines/app_merge.nim \
     src/pdf_toc_outlines/app_outlines.nim \
     src/pdf_toc_outlines/app_subst.nim \
     src/pdf_toc_outlines/fitz_common.nim \
     src/pdf_toc_outlines/options.nim \
     src/pdf_toc_outlines/pdf_common.nim \
     src/pdf_toc_outlines/pdf_doc.nim \
     src/pdf_toc_outlines/pdf_links.nim \
     src/pdf_toc_outlines/pdf_open.nim \
     src/pdf_toc_outlines/pdf_outlines.nim \

exe:=pdf-toc-outlines
prefix:=/usr/local

all:     $(exe)

build:   $(exe)

$(exe):  export PATH:=$(PATH):/usr/local/bin
$(exe):  $(src)
	nimble build
	mv -f $(subst -,_,$(exe)) $(exe)

install: $(exe)
	install -D $< $(DESTDIR)$(prefix)/bin/$(notdir $<)


deb:   pkg:=pdf-toc-outlines-0.1
deb:   files:=src Makefile LICENSE pdf_toc_outlines.nimble
deb:   $(exe)
	rm -rf   build/$(pkg)
	rm -f    build/$(pkg).tar.gz
	mkdir -p build/$(pkg)/debian
	cp -r build/debian-rules/* build/$(pkg)/debian
	tar czvf build/$(pkg).tar.gz --transform s,^src,$(pkg)/src, $(files)
	cp -r $(files)  build/$(pkg)
	cd       build/$(pkg); debmake
	cd       build/$(pkg); EDITOR=/bin/true dpkg-source --commit . 1
	cd       build/$(pkg); debuild


.PHONY: all build deb install
