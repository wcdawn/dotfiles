#!/bin/bash

usage ()
{
  echo 'Usage:'
  echo "$0 [-jNPROC]"
  echo '[-jNPROC] Number of processors for make compiling.'
  echo '[-o] Try to compile optional packages as well.'
  exit 0
}

check_dependency ()
{
  if ! [ -x "$(command -v $1)" ]
  then
    echo "It appears the command '$1' is not on the system."
    echo 'This is a dependency for this script.'
    exit 1
  fi
}

MAKEOPT=''
OPTIONAL=''
while getopts "j:oh" opt # trailing colon specifies an arguemnt is required
do
  case ${opt} in
    j) # parallel make
      MAKEOPT="--makeflags -j${OPTARG}"
      ;;
    o) # optional
      OPTIONAL='--optional'
      echo 'WARNING: optional plugins/dependencies will be installed.'
      echo 'This is untested and often breaks VisIt.'
      ;;
    h) # help
      usage
      exit 0
      ;;
    \?) # error
      echo 'invalid argument'
      usage
      exit 1
  esac
done

# this isn't really necessary but may be important in the future
shift $((OPTIND - 1)) # shift to ignore already parsed command line arguments
  
COMMAND_ARR=('wget' 'unzip' 'qmake' 'cpio')

for COMMAND in ${COMMAND_ARR[@]}
do
  check_dependency $COMMAND
done

rm -rf $HOME/pkg/visit_build
mkdir -p $HOME/pkg/visit_build
cd $HOME/pkg/visit_build

VERS_DOT='3.1.1'
VERS_USCORE=$(echo ${VERS_DOT} | sed 's/\./_/g')
SCRIPT=build_visit${VERS_USCORE}
URL=https://github.com/visit-dav/visit/releases/download/v${VERS_DOT}/${SCRIPT}

curl -L ${URL} > ${SCRIPT}
chmod +x ${SCRIPT}

# automatically answer "yes" to any questions about making directories or
# accepting licenses

# use parallel make if the user has specified this

# use system Qt
# ESSENTIAL! The Qt version included in the VisIt build script is broken af.

# hdf5 and xdmf are included for LUPINE files

# openssl and zlib must be specified manually for some versions of VisIt

# consider adding --optional to install all optional libraries
# this option is untested and liable to break with different versions of VisIt

yes yes | ./${SCRIPT} ${MAKEOPT} ${OPTIONAL} \
  --system-qt --hdf5 --xdmf --openssl --zlib

VERSION=${VERS_DOT}
ARCH='linux-x86_64'
INSTALL_DIR_PATH="$HOME/pkg/visit"

rm -rf ${INSTALL_DIR_PATH}
mkdir -p ${INSTALL_DIR_PATH}

# default to no university/lab configuration file
echo '1' | ./visit-install ${VERSION} ${ARCH} ${INSTALL_DIR_PATH}

rm -rf $HOME/pkg/visit_build

VISIT_SCRIPT=$HOME/bin/visit
echo '#!/bin/sh' > ${VISIT_SCRIPT}
echo "${INSTALL_DIR_PATH}/bin/visit" >> ${VISIT_SCRIPT}
chmod +x ${VISIT_SCRIPT}
