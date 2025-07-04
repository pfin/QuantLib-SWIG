# Makefile.am for QuantLib-SWIG JavaScript bindings

CLEANFILES = quantlib_wrap.cxx build

BUILT_SOURCES = quantlib_wrap.cxx

if BUILD_JAVASCRIPT

all-local: .build-stamp

.build-stamp: quantlib_wrap.cxx
	npm install
	npm run build
	touch .build-stamp

quantlib_wrap.cxx: ../SWIG/*.i
	$(SWIG) -javascript -node -c++ -o quantlib_wrap.cxx \
		-I$(srcdir)/../SWIG -I$(srcdir) \
		$(srcdir)/../SWIG/quantlib.i

check-local: .build-stamp
	npm test

install-exec-local: .build-stamp
	npm pack

clean-local:
	rm -rf build node_modules
	rm -f .build-stamp quantlib_wrap.cxx
	npm run clean || true

endif