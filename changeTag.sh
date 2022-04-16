#!/bin/bash
sed "s/version/$1/g" kubernetes.yml > kubernetes-deploy.yml
