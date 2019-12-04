ARG CUDA_VERSION=10.1
ARG CUDA_UBUNTU_VERSION=16.04
ARG AMDGPU_VERSION=17.40-514569
ARG GIT_REPOSITORY=https://github.com/xmrig/xmrig.git
ARG GIT_BRANCH=v5.1.0


ENV DEBIAN_FRONTEND=noninteractive \
    GIT_REPOSITORY=${GIT_REPOSITORY_CUDA} \
    GIT_BRANCH=${GIT_BRANCH_CUDA}
ENV CMAKE_FLAGS "-DCUDA_LIB=/usr/local/cuda/lib64/stubs/libcuda.so -DCMAKE_CXX_FLAGS=-std=c++11"
ENV PACKAGE_DEPS "build-essential cmake git"

WORKDIR /tmp



FROM ubuntu:${CUDA_UBUNTU_VERSION} AS build

ARG GIT_REPOSITORY
ARG GIT_BRANCH

ENV DEBIAN_FRONTEND=noninteractive \
    GIT_REPOSITORY=${GIT_REPOSITORY} \
    GIT_BRANCH=${GIT_BRANCH}
ENV CMAKE_FLAGS "-DWITH_OPENCL=ON -DWITH_CUDA=ON -DWITH_NVML=ON"
ENV PACKAGE_DEPS "build-essential ca-certificates cmake git libhwloc-dev libmicrohttpd-dev libssl-dev libuv1-dev ocl-icd-opencl-dev"

COPY donate-level.patch /tmp

WORKDIR /tmp

RUN  set -x \
  && dpkg --add-architecture i386 \
  && apt-get update -qq \
  && apt-get install -qq --no-install-recommends -y ${PACKAGE_DEPS} \
  && git clone --single-branch --depth 1 --branch $GIT_BRANCH $GIT_REPOSITORY xmrig \
  && git -C xmrig apply /tmp/donate-level.patch \
  && cd xmrig \
  && cmake ${CMAKE_FLAGS} . \
  && make \
  && apt-get purge -qq -y ${PACKAGE_DEPS} \
  && apt-get autoremove -qq -y \
  && apt-get clean autoclean -qq -y \
  && rm -rf /var/lib/{apt,dpkg,cache,log}


COPY --from=build /tmp/xmrig/xmrig /usr/local/bin/

USER miner

WORKDIR /config
VOLUME /config

ENTRYPOINT ["/usr/local/bin/xmrig"]

CMD ["--help"]
