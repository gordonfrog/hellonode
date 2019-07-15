#!/bin/bash
source ~/.bashrc

GITSHA=$(git rev-parse --short HEAD)

case "$1" in
  container)
    sudo -u williamgordon docker build -t hellonode:$GITSHA .
    sudo -u williamgordon docker tag hellonode:$GITSHA gordonfrog/hellonode:$GITSHA 
    sudo -i -u williamgordon docker push gordonfrog/hellonode:$GITSHA 
  ;;
  deploy)
    sed -e s/_NAME_/hellonode/ -e s/_PORT_/9091/  < ../deployment/service-template.yml > svc.yml
    sed -e s/_NAME_/hellonode/ -e s/_PORT_/9091/ -e s/_IMAGE_/gordonfrog\\/hellonode:$GITSHA/ < ../deployment/deployment-template.yml > dep.yml
    sudo -i -u williamgordon kubectl apply -f $(pwd)/svc.yml
    sudo -i -u williamgordon kubectl apply -f $(pwd)/dep.yml
  ;;
  *)
    echo 'invalid build command'
    exit 1
  ;;
esac

