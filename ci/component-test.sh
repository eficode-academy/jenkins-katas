#! /bin/bash
docker-compose -f component-test/docker-compose.yml --project-directory . -p ci up --build --exit-code-from sut