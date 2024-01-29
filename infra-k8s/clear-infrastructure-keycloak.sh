#!/bin/bash

# Definindo variáveis
NAMESPACE="app-env"
RESOURCE_NAMESPACE="namespace/"
RESOURCE_CONFIGMAP="config-map/"
DIR_INFRA="infrastructure"
DIR_APP="application"
DIR_SECRET=$DIR_INFRA"/secret"
DIR_KEYCLOAK=$DIR_INFRA"/keycloak"
RESOURCE_LIMITS=$DIR_INFRA"/limits/"
RESOURCE_DATABASE=$DIR_INFRA"/database"
RESOURCE_VOLUME=$RESOURCE_DATABASE"/keycloak-database-persistent-volume.yaml" 
RESOURCE_DATABASE_STATEFUL=$RESOURCE_DATABASE"/keycloak-database-statefull-set.yaml" 
RESOURCE_DATABASE_SERVICE=$RESOURCE_DATABASE"/keycloak-database-service.yaml"
RESOURCE_KEYCLOAK_STATEFUL=$DIR_KEYCLOAK"/keycloak-statefull.yaml" 
RESOURCE_KEYCLOAK_SERVICE=$DIR_KEYCLOAK"/keycloak-service.yaml"
RESOURCE_KEYCLOAK_HPA=$DIR_KEYCLOAK"/keycloak-hpa.yaml"


apply() {
  
  $1

  # Verifica o status de saída do comando kubectl
  status_saida=$?

  # Se o status de saída for diferente de zero (indicando erro)
  if [ $status_saida -ne 0 ]; then
    echo "Ocorreu um erro na execução do comando kubectl."
    exit 1  # Encerra o script com código de erro 1
  fi
}

unInstall(){  
  apply "kubectl delete -f $DIR_KEYCLOAK"
  echo "------removing keycloak--------"
}

unInstall
