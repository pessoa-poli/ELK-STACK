db_elastic := /dados/data/cam_bi_elastic

start:
	@ls ${db_elastic} && \
	echo Diretorio ${db_elastic} já existe || \
	mkdir ${db_elastic} -p && \
	ls docker-data-volumes || tar -xf docker-data-volumes.tar && \
	echo Criando diretório ${db_elastic} && \
	echo Copiando dados do ES && \
	cp docker-data-volumes/* ${db_elastic}/ -R
	@docker network create camboxNet && echo Network camboxNet criada com sucesso || \
	echo A network camboxNet não foi criada. Se algo der errado verifique se a network já existe ou tente criar a network com o comando "docker network create camboxNet"
	@echo Mudando permissoes de alguns arquivos.
	@chmod 666 elastic-certificates.p12
	@chmod 666 elastic-stack-ca.p12
	@chmod 777 ${db_elastic} -R	
	docker-compose up --remove-orphans -d

check-certificate:
	@ echo checking certificate end date
	@ echo Password vazio, aperte ENTER!
	@ openssl pkcs12 -in elastic-certificates.p12 -out mycert.pem -nodes
	@ cat mycert.pem | openssl x509 -noout -enddate
	@ rm mycert.pem

check-ca:
	@ echo checking CA end date
	@ echo Password vazio, aperte ENTER!
	@ openssl pkcs12 -in elastic-stack-ca.p12 -out mycert.pem -nodes
	@ cat mycert.pem | openssl x509 -noout -enddate
	@ rm mycert.pem

diff-no-data-volumes:
	git diff -- . ':(exclude)docker-data-volumes/*'
status-no-data-volumes:
	git status -- . ':(exclude)docker-data-volumes/*'