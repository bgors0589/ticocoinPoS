To be able to use nested vms, install docker-machine-kvm plugin from https://github.com/dhiltgen/docker-machine-kvm/

Create new docker-machine with kvm plugin, make sure that network is started (virsh net-start default)

	docker-machine create -d kvm --kvm-cpu-count	2 --kvm-memory 4096 --kvm-disk-size 40000 default

Start and login into docker-machine host to activate kvm module, ie

	docker-machine ssh default sudo modprobe kvm_intel

From Ticocoin repository root build the peergitian/base image:

    docker build -t peergitian/base $PWD/contrib/gitian-docker

Then the peergitian/setup image:

    ID=`docker run --privileged -d -v $PWD:/ticocoin -t peergitian/base /setup.sh` && docker attach $ID
    docker commit $ID peergitian/setup

If the setup fails you should still commit the container to save the current state. Then you can start the container to complete the jobs manually and commit again:

    ID=`docker run --privileged -d -v $PWD:/ticocoin -ti peergitian/setup bash` && docker attach $ID
    service apt-cacher-ng start
    cd gitian-builder
    # finish the setup process manually and exit the container
    docker commit $ID peergitian/setup


Then you must choose to either build from your local repository or from the official repository.

To build from your local repository:

* modify `contrib/gitian-descriptors/gitian-linux.yml` and `contrib/gitian-descriptors/gitian-win.yml`: replace the line `- "url": "https://github.com/ticocoin/ticocoin"` with `- "url": "/ticocoin"`
* start the container with `docker run --privileged -ti -w /gitian-builder -v $PWD:/ticocoin peergitian/setup bash`

To build from the official repository start the container with this command:

    docker run --privileged -ti -w /gitian-builder -v $PWD:/ticocoin peergitian/setup bash

Then you're inside the container. Verify KVM is working:

    kvm-ok

Start apt-cacher-ng:

    service apt-cacher-ng start

Then define the version you want to build (v$VERSION must be an annotated tag on the target repository):

    export VERSION=0.6.0ppc

Then to build the Linux binaries:

    ./bin/gbuild --commit ticocoin=v${VERSION} ../ticocoin/contrib/gitian-descriptors/gitian-linux.yml
    pushd build/out
    zip -r ticocoin-${VERSION}-linux-gitian.zip *
    mv ticocoin-${VERSION}-linux-gitian.zip /ticocoin/
    popd

And to build the Windows binaries:

    ./bin/gbuild --commit ticocoin=v${VERSION} ../ticocoin/contrib/gitian-descriptors/gitian-win.yml
    pushd build/out
    zip -r ticocoin-${VERSION}-win-gitian.zip *
    mv ticocoin-${VERSION}-win-gitian.zip /ticocoin/
    popd
