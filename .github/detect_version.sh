echo "VERSION=${VERSION}"
echo "export VERSION=${VERSION}" >> $GITHUB_ENV
echo "COMPILER=${COMPILER}"
echo "export COMPILER=${COMPILER}" >> $GITHUB_ENV
echo "MPI=${MPI}"
echo "export MPI=${MPI}" >> $GITHUB_ENV
echo "LIBS=${LIBS}"
echo "export LIBS=${LIBS}" >> $GITHUB_ENV
echo "IMAGE_TAG=${GITHUB_SHA:0:7}"
echo "export IMAGE_TAG=${GITHUB_SHA:0:7}" >> $GITHUB_ENV
echo ${GITHUB_TOKEN} | docker login ghcr.io -u ${ACTOR} --password-stdin
