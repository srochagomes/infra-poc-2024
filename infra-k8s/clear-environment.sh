#!/bin/bash

# Definindo variáveis
NAMESPACE="app-env"
RESOURCE_NAMESPACE="namespace/"
RESOURCE_CONFIGMAP="config-map/"
DIR_INFRA="infraestructure"
RESOURCE_LIMITS=$DIR_INFRA"/limits/"
RESOURCE_DATABASE=$DIR_INFRA"/database"
RESOURCE_VOLUME=$RESOURCE_DATABASE"/keycloak-database-persistent-volume.yaml" 
RESOURCE_DATABASE_STATEFUL=$RESOURCE_DATABASE"/keycloak-database-statefull-set.yaml" 
RESOURCE_DATABASE_SERVICE=$RESOURCE_DATABASE"/keycloak-database-service.yaml"


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

unInstallIstio(){
  NAMESPACE_ISTIO="istio-system"
  NAMESPACE_APP="feriaz-app-env"
  NAMESPACE_AUTH="feriaz-auth-env"
  echo "------Uninstalling Istio--------"
  export PATH=$PWD/istio-1.20.2/bin:$PATH
  apply "istioctl uninstall --purge -y"
  apply "kubectl delete namespace $NAMESPACE_ISTIO --ignore-not-found=true"
  apply "kubectl delete namespace $NAMESPACE_APP --ignore-not-found=true"
  apply "kubectl delete namespace $NAMESPACE_AUTH --ignore-not-found=true"
  echo "------removing application--------"
}

unInstallIstio
