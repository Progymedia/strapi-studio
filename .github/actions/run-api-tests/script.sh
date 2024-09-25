export STRAPI_DISABLE_LICENSE_PING=true
export ENV_PATH="$(pwd)/test-apps/api/.env"
export JWT_SECRET="aSecret"

opts=($DB_OPTIONS)
jestOptions=($JEST_OPTIONS)

yarn run test:generate-app:no-build --appPath=test-apps/api "${opts[@]}"
yarn run test:api --no-generate-app "${jestOptions[@]}"
