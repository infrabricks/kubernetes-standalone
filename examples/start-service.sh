#!/bin/bash
require_command_exists() {
    command -v "$1" >/dev/null 2>&1 || { echo "$1 is required but is not installed. Aborting." >&2; exit 1; }
}

require_command_exists kubectl

SERVICE=${1:-nginx}
S_EXISTS=$(kubectl get service -lname=${SERVICE} | tail -n +2)
if [ "z${S_EXISTS}" == "z" ] ; then
  kubectl create -f ${SERVICE}.service.json
fi

RC=${1:-nginx}
RC_EXISTS=$(kubectl get rc -lname=${RC} | tail -n +2)
if [ "z${RC_EXISTS}" == "z" ] ; then
  kubectl create -f ${RC}.controller.json
else
  kubectl delete rc/${RC}
  kubectl create -f ${RC}.controller.json
fi
