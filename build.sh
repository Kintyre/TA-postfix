#!/bin/bash
git_wd=$(pwd)

function RUN(){
    echo "RUN " "$@"
    "$@"
}

# Run in a fresh virtual env; shouldn't be needed when running in Travis CI 
if [[ -z $VIRTUAL_ENV ]]
    then
    if ! [[ -d "venv" ]]
        then
        RUN virtualenv venv || exit 1
        # Upgrade to pip10  due to:  TLSV1_ALERT_PROTOCOL_VERSION
        RUN curl -s https://bootstrap.pypa.io/get-pip.py -o get-pip.py
        RUN python get-pip.py
    fi
    echo "Activating virtualenvironment"
    source venv/bin/activate || exit

fi

RUN curl -sL http://dev.splunk.com/goto/appinspectdownload -o splunk-appinspect.tar.gz || exit 1
#Todo:  Verify the MD5/SHA (download broken when I just checked)
pkg=splunk-appinspect.tar.gz

# Testing with a local pre-downloaded package
#pkg=splunk-appinspect-1.5.4.145.tar.gz 

# No need to extract manually....
##appinspect_dir=$(mktemp -d)
##echo "Using temp dir $appinspect_dir"
##RUN tar -xzvf splunk-appinspect.tar.gz -C "$appinspect_dir" || exit 1
# Should be only one new subdirectory from download
##pkg="$appinspect_dir"/*

RUN pip install "$pkg"
RUN ./release.sh
pkg=$(cat latest_release)

RUN splunk-appinspect list version
RUN splunk-appinspect inspect "$pkg" --mode precert --included-tags cloud
