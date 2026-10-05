# Built by .github/workflows/deploy.yml (context ., file Dockerfile) and pushed
# to Artifact Registry.
#
# A job image, not a server: the default command runs scripts/check.sh
# (fmt -check, init, validate, plan) and exits 0 when all of it passes. It never
# listens on $PORT.
#
# Providers are downloaded at BUILD time (`terraform init`, checked against the
# committed .terraform.lock.hcl), so the job itself needs no registry access.

FROM hashicorp/terraform:1.16.5 AS runtime
ARG BUILD_ID=""
ENV BUILD_ID=$BUILD_ID TF_IN_AUTOMATION=1 TF_INPUT=0 HOME=/home/app
RUN adduser -D -u 10001 -h /home/app app \
 && mkdir /app && chown app:app /app
WORKDIR /app
COPY --chown=app:app . .
USER app
RUN terraform init -input=false -lockfile=readonly
# the base image's ENTRYPOINT is `terraform`; the job is a script
ENTRYPOINT []
CMD ["sh", "scripts/check.sh"]
