#!/usr/bin/env bash

VERSION=$1
docker build -t vit0r/airflow:${VERSION} .
docker push vit0r/airflow:${VERSION}