#!/bin/bash

function RUN(){
    echo "RUN " "$@"
    "$@"
}

# Run in a fresh virtual env if 'splunk-appinspect' isn't available
BIN=$(which splunk-appinspect)
if [[ -z $BIN ]]
    then
    if ! [[ -d "venv" ]]
        then
        RUN virtualenv venv || exit 1

        # Upgrade to pip10  due to:  TLSV1_ALERT_PROTOCOL_VERSION
        RUN curl -s https://bootstrap.pypa.io/get-pip.py -o get-pip.py
        RUN python get-pip.py

        RUN curl -sL http://dev.splunk.com/goto/appinspectdownload -o splunk-appinspect.tar.gz || exit 1
        #Todo:  Verify the MD5/SHA (download broken when I just checked)
        pkg=splunk-appinspect.tar.gz

        RUN pip install "$pkg"
    fi
    echo "Activating virtualenvironment"
    source venv/bin/activate || exit
fi
RUN splunk-appinspect list version || exit


RUN ./release.sh
pkg=$(cat latest_release)

RUN splunk-appinspect inspect "$pkg" --mode precert --included-tags cloud
