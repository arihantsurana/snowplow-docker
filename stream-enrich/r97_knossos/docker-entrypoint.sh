#!/usr/bin/dumb-init /bin/sh
set -e

# If the config directory has been mounted through -v, we chown it.
if [ "$(stat -c %u ${SNOWPLOW_CONFIG_PATH})" != "$(id -u snowplow)" ]; then
  chown snowplow:snowplow ${SNOWPLOW_CONFIG_PATH}
fi

# Needed because of SCE's ./ip_geo file
cd $(eval echo ~snowplow)

# Make sure we run the collector as the snowplow user
exec su-exec snowplow:snowplow ${SNOWPLOW_BIN_PATH}/snowplow-emr-etl-runner run -c ${SNOWPLOW_CONFIG_PATH}/config.yml -n ${SNOWPLOW_CONFIG_PATH}/enrichments/ -r ${SNOWPLOW_CONFIG_PATH}/resolver.conf -t ${SNOWPLOW_CONFIG_PATH}/targets/ -l ${SNOWPLOW_CONFIG_PATH}/emr.lock -x analyze
