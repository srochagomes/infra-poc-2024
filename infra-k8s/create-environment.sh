#!/bin/bash

# Definindo variáveis
NAMESPACE="app-env"
RESOURCE_NAMESPACE="namespace/"
RESOURCE_CONFIGMAP="config-map/keycloak-service-configmap.yaml"
RESOURCE_COMPONENTS="components/"
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
RESOURCE_AUTHBASE=$RESOURCE_COMPONENTS/auth-server

installIstio(){
    # Nome do namespace que você deseja verificar
    NAMESPACE_ISTIO="istio-system"

    # Verifica se o namespace já existe usando o kubectl
    if kubectl get namespace $NAMESPACE_ISTIO &> /dev/null; then
        echo "Istio já instalado"
    else
        echo "------Installing Istio--------"
        export PATH=$PWD/istio-1.20.2/bin:$PATH
        apply "istioctl install --set profile=default -y --set values.global.jwtPolicy=third-party-jwt"
        echo "------Configure injection sidecar Istio--------"
        apply "kubectl label namespace default istio-injection=enabled --overwrite"
        apply "kubectl label namespace feriaz-app-env istio-injection=enabled --overwrite"
        apply "kubectl label namespace feriaz-auth-env istio-injection=enabled --overwrite"
        echo "------Apply all addons--------"
        kubectl apply -f istio-1.20.2/samples/addons
    fi
}

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

echo "------Create namespace: $NAMESPACE"
apply "kubectl apply -f $RESOURCE_NAMESPACE"
echo "------Preparing to install Istio--------"
installIstio
echo "------Create secret: $DIR_SECRET"
apply "kubectl apply -f $DIR_SECRET"
echo "------Create config: $RESOURCE_CONFIGMAP"
apply "kubectl apply -f $RESOURCE_CONFIGMAP"

echo "------Create keycloak stateful------"
apply "kubectl apply -f $DIR_KEYCLOAK"

#echo "------Create AUTHServer ------"
#apply "kubectl apply -f $RESOURCE_AUTHBASE"


