DOCKER_IMAGE_NAME ?= card-me:latest
DOCKER_WORK_DIR ?= /opt/src
DOCKER_RUN ?= docker run --rm -it --user "$(shell id -u):$(shell id -g)" -v ${CURDIR}:${DOCKER_WORK_DIR}

build:
	docker build -t ${DOCKER_IMAGE_NAME} ${BUILD_ARGS} .

rebuild:
	BUILD_ARGS="--no-cache" make docker_build

shell:
	${DOCKER_RUN} ${DOCKER_IMAGE_NAME} /bin/bash

lint:
	${DOCKER_RUN} ${DOCKER_IMAGE_NAME} make lint_local

lint_local:
	flake8 .

typing:
	${DOCKER_RUN} ${DOCKER_IMAGE_NAME} make typing_local

typing_local:
	mypy ms_client

deadcode:
	${DOCKER_RUN} ${DOCKER_IMAGE_NAME} make deadcode_local

deadcode_local:
	vulture --exclude .eggs --min-confidence 90 .

test:
	${DOCKER_RUN} -e "PYTEST_ARGS=${PYTEST_ARGS}" ${DOCKER_IMAGE_NAME} make test_local

test_local:PYTEST_ARGS := $(or ${PYTEST_ARGS},--cov --no-cov-on-fail --junitxml=report.xml --cov-report xml --cov-report term --cov-report html)
test_local:
	pytest ${PYTEST_ARGS}

clean:
	rm -rf .coverage .pytest_cache .local .eggs build dist *.egg-info
	find . -type f -name *.pyc -delete
	find . -type d -name __pycache__ -delete
