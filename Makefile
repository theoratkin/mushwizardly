gd = godot --export-release
builddir = build
name = Mushwizardly
version := $(file < VERSION)
butler = butler push --userversion $(version)
butler_target = theoratkin/mushwizardly


all: web linux64 win64

linux64:
	$(gd) $@ $(builddir)/$@/$(name).x86_64

win64:
	$(gd) $@ $(builddir)/$@/$(name).exe

web:
	$(gd) $@ $(builddir)/$@/index.html


publish: publish-web publish-linux64 publish-win64

define publish
	$(butler) $(builddir)/$(subst publish-,,$@) $(butler_target):$(subst publish-,,$@)
endef

publish-web:
	$(call publish)

publish-linux64:
	$(call publish)

publish-win64:
	$(call publish)
