export ELASTIC_APM_ENVIRONMENT="staging"
export ELASTIC_APM_SECRET_TOKEN=$(aws ssm get-parameter --name "/observability/elastic-apm/token" --with-decryption | jq -r '.Parameter.Value')
export ELASTIC_APM_SERVER_CA_CERT_FILE="/usr/local/share/ca-certificates/nosto-root-ca.crt"
export ELASTIC_APM_SERVER_URL=$(aws ssm get-parameter --name "/observability/elastic-apm/url" --with-decryption | jq -r '.Parameter.Value')
export ELASTIC_APM_SERVICE_NAME="ugc-ml-flask"
export FLAIR_CACHE_ROOT="/tmp/.flair"

