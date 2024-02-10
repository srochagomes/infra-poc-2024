#!/bin/bash

apply() {

  $1 

  # Verifica o status de saída do comando kubectl
  status_saida=$?

  # Se o status de saída for diferente de zero (indicando erro)
  if [ $status_saida -ne 0 ]; then
    echo "Ocorreu um erro na execução do comando."
    exit 1  # Encerra o script com código de erro 1
  fi
}


waitService(){
  PORTA=$1 

  # Aguarda até que a porta esteja ativa
  while ! netstat -tuln | grep ":$PORTA " > /dev/null; do
      sleep 1
  done

  # A porta está ativa, continue com o restante do script
  echo "A porta $PORTA está ativa."
}


startDockerCompose(){
  echo "Verificando DockerCompose."
  cd infra-docker/
  sudo docker-compose build && sudo docker-compose up -d
  cd ..
  return $!
}


startDockerCompose


sudo systemctl restart nginx

echo "Ambiente Configurado."

