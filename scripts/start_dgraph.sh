  
#!/usr/bin/env bash

DGRAPH_CONTAINER_NAME=dlex-dgraph-test

if docker ps -a --format '{{.Names}}' | grep -Eq "^${DGRAPH_CONTAINER_NAME}\$"; then
  echo "Already running..."
else
  echo "Starting local dgraph server via Docker..."
  docker run --name $DGRAPH_CONTAINER_NAME -p 18000:8000 -p 18080:8080 -p 19080:9080 -d dgraph/standalone:latest
fi
echo "Done."
