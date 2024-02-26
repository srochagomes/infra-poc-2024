#!/bin/bash

# Definindo variáveis
RESOURCE_CONFIGMAP_AUTHBASE="config-map/auth-base-configmap.yaml"
RESOURCE_CONFIGMAP_GATEWAY="config-map/gateway-configmap.yaml"
RESOURCE_CONFIGMAP_ACCOUNT="config-map/account-configmap.yaml"
RESOURCE_CONFIGMAP_COMMUNICATION="config-map/communication-configmap.yaml"
RESOURCE_CONFIGMAP_SEARCH_DOMAIN="config-map/search-domain-configmap.yaml"

RESOURCE_COMPONENTS="components/"
DIR_INFRA="infrastructure"
DIR_APP="application"
DIR_SECRET=$DIR_INFRA"/secret"
RESOURCE_LIMITS=$DIR_INFRA"/limits/"
RESOURCE_DATABASE=$DIR_INFRA"/database"
RESOURCE_AUTHBASE=$RESOURCE_COMPONENTS/auth-server
RESOURCE_GATEWAY=$RESOURCE_COMPONENTS/gateway
RESOURCE_ACCOUNT=$RESOURCE_COMPONENTS/account
RESOURCE_COMMUNICATION=$RESOURCE_COMPONENTS/communication
RESOURCE_SEARCH_DOMAIN=$RESOURCE_COMPONENTS/search-domain

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


echo "------Create secret: $DIR_SECRET"
apply "kubectl apply -f $DIR_SECRET"
echo "------Create config: $RESOURCE_CONFIGMAP"
apply "kubectl apply -f $RESOURCE_CONFIGMAP_AUTHBASE"
echo "------Create config: $RESOURCE_CONFIGMAP_GATEWAY"
apply "kubectl apply -f $RESOURCE_CONFIGMAP_GATEWAY"
echo "------Create config: $RESOURCE_CONFIGMAP_ACCOUNT"
apply "kubectl apply -f $RESOURCE_CONFIGMAP_ACCOUNT"
echo "------Create config: $RESOURCE_CONFIGMAP_COMMUNICATION"
apply "kubectl apply -f $RESOURCE_CONFIGMAP_COMMUNICATION"
echo "------Create config: $RESOURCE_CONFIGMAP_SEARCH_DOMAIN"
apply "kubectl apply -f $RESOURCE_CONFIGMAP_SEARCH_DOMAIN"


echo "------Create AUTHServer ------"
apply "kubectl replace -f $RESOURCE_AUTHBASE"

echo "------Create Gateway ------"
apply "kubectl replace -f $RESOURCE_GATEWAY"

echo "------Create Account ------"
apply "kubectl replace -f $RESOURCE_ACCOUNT"

echo "------Create Communication ------"
apply "kubectl replace -f $RESOURCE_COMMUNICATION"

echo "------Create Search Domain ------"
apply "kubectl apply -f $RESOURCE_SEARCH_DOMAIN"



