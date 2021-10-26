#!/bin/bash

VERSION=$1

if [[ -n "$VERSION" ]]; then
	echo ${VERSION}
else
    echo "argument error, provide commit, branch or tag"
	exit
fi

cd /gitian-builder/

./bin/gbuild --commit ticocoin=${VERSION} ../ticocoin/contrib/gitian-descriptors/gitian-linux.yml
pushd build/out
zip -r ticocoin-${VERSION}-linux-gitian.zip *
mv ticocoin-${VERSION}-linux-gitian.zip /ticocoin/
popd

./bin/gbuild --commit ticocoin=${VERSION} ../ticocoin/contrib/gitian-descriptors/gitian-win.yml
pushd build/out
zip -r ticocoin-${VERSION}-win-gitian.zip *
mv ticocoin-${VERSION}-win-gitian.zip /ticocoin/
popd

./bin/gbuild --commit ticocoin=${VERSION} ../ticocoin/contrib/gitian-descriptors/gitian-osx.yml
pushd build/out
zip -r ticocoin-${VERSION}-osx-gitian.zip *
mv ticocoin-${VERSION}-osx-gitian.zip /ticocoin/
popd

echo "build complete, files are in /ticocoin/ directory"
