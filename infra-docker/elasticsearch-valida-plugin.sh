#!/bin/bash

# Verificar se o plugin já está instalado
if /usr/share/elasticsearch/bin/elasticsearch-plugin list | grep -q analysis-phonetic; then
  echo "O plugin analysis-phonetic já está instalado."
else
  echo "Instalando o plugin analysis-phonetic..."
  /usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-phonetic
fi

# Iniciar o Elasticsearch
exec /usr/local/bin/docker-entrypoint.sh