#!/bin/bash

# Esse script pode ser usado para recriar os certificados usados pelo elastic. Ele foi mantido para referência, e sua deleção não afeta em nada o deploy da base de BI.

CERT_UTIL="/usr/share/elasticsearch/bin/elasticsearch-certutil"
CA_PATH="/usr/share/elasticsearch/elastic-stack-ca.p12"
CERT_PATH="/usr/share/elasticsearch/elastic-certificates.p12"
CAM_ES='cam_bi_elastic'
gen() {
  docker exec -it ${CAM_ES} bash -c "printf \"\\n\" | rm ${CA_PATH}"
  docker exec -it ${CAM_ES} bash -c "printf \"\\n\" | rm ${CERT_PATH}"
  docker exec -it ${CAM_ES} bash -c "printf \"\\n\" | ${CERT_UTIL} ca --pass ''"
  docker exec -it ${CAM_ES} bash -c "printf \"\\n\" | ${CERT_UTIL} cert --days 3650 --ca ${CA_PATH} --ca-pass '' --pass ''" 
}

copy() {
  echo "Copying certificates"
  docker cp ${CAM_ES}:/usr/share/elasticsearch/elastic-stack-ca.p12 elastic-stack-ca.p12
  docker cp ${CAM_ES}:/usr/share/elasticsearch/elastic-certificates.p12 elastic-certificates.p12
} 

changeperms() {
	chmod 666 elastic-certificates.p12
	chmod 666 elastic-stack-ca.p12
	chmod -R 777 docker-data-volumes
}

create_data_dirs(){
  mkdir -p "docker-data-volumes/elasticsearch"
}

gen
copy
create_data_dirs
changeperms
