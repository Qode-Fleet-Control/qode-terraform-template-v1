#!/bin/sh
# The job: format check, init, validate, plan. Exits non-zero on the first failure.
set -eu
cd "$(dirname "$0")/.."
echo "==> terraform fmt -check";  terraform fmt -check -recursive -diff
echo "==> terraform init";        terraform init -input=false -lockfile=readonly
echo "==> terraform validate";    terraform validate
echo "==> terraform plan";        terraform plan -input=false -lock=false
