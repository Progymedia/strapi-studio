export STRAPI_DISABLE_LICENSE_PING=true

jestOptions=($JEST_OPTIONS)

yarn test:e2e --setup --concurrency=1 "${jestOptions[@]}"