#!/bin/bash

# externally
URL='https://github.com/gchq/CyberChef'
LATEST='releases/latest/'
MATCH='releases/tag/'

# locally
TEMP_FILE='/tmp/cyber.html'
CYBERCHEF_LOC='/home/'$(whoami)'/scripts/html'
OLD_VERSION="${CYBERCHEF_LOC}/.cyberchef_old_version.txt"
CYBERCHEF='/tmp/cyberchef.zip'
CYBERCHEFDIR='/tmp/cyberchef'


#############
# FUNCTIONS #
#############

_sanity_checks() {
    # Ensure we have scripts directory in place
    if [ ! -d ${CYBERCHEF_LOC} ]; then
        mkdir -p ${CYBERCHEF_LOC}
    fi

    # Ensure we have a cyberchef directory for unpacking zip-file to
    if [ -d ${CYBERCHEFDIR} ]; then
        rm -rf ${CYBERCHEFDIR}
        mkdir ${CYBERCHEFDIR}
    else
        mkdir ${CYBERCHEFDIR}
    fi

    # Ensure we have a version file for comparison
    if [ ! -f ${OLD_VERSION} ]; then
        echo '1' > ${OLD_VERSION}
    fi

}

_unpack_cyberchef() {
    unzip ${CYBERCHEF_LOC}/cyberchef.zip -d ${CYBERCHEFDIR}
    cp ${CYBERCHEFDIR}/CyberChef_${VERSION}.html ${CYBERCHEFDIR}/cyberchef.html
}

_get_cyberchef() {
    wget ${URL}/releases/download/${VERSION}/CyberChef_${VERSION}.zip -O ${CYBERCHEF} 2> /dev/null
}


################
# MAIN PROGRAM #
################

_sanity_checks

# Get html-page for the latest cyberchef release and grab the latest version number:
wget ${URL}/${LATEST} -O ${TEMP_FILE} 2> /dev/null
VERSION=$( grep ${MATCH} ${TEMP_FILE} | sed -e 's_.*releases/tag/__g' | sed -e 's_".*__g' | tail -n1 )

OLD_VERS=$( cat ${OLD_VERSION} )

if [ x"${OLD_VERS}" == x"${VERSION}" ]; then
    _unpack_cyberchef
else
    _get_cyberchef
    cp ${CYBERCHEF} ${CYBERCHEF_LOC}/
    echo ${VERSION} > ${OLD_VERSION}
    _unpack_cyberchef
fi



