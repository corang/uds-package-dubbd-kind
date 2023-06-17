#!/bin/bash

# Get current dubbd tag
DUBBD_TAG=$(yq '.package.create.set.package_version' ${GITHUB_WORKSPACE}/zarf-config.yaml)

# Store upstream zarf-config.yaml in variable
UPSTREAM_ZARF_CONFIG=$(curl -s https://raw.githubusercontent.com/defenseunicorns/uds-package-dubbd/${DUBBD_TAG}/defense-unicorns-distro/zarf-config.yaml)

# Get our bigbang version
CURRENT_BB_VERSION=$(yq '.package.create.set.bigbang_version' ${GITHUB_WORKSPACE}./zarf-config.yaml)

# Get upstream bigbang version
UPSTREAM_BB_VERSION=$(echo "${UPSTREAM_ZARF_CONFIG}" | yq '.package.create.set.bigbang_version')

# Get newer of two versions
NEWER_VERSION=$(echo -e "${CURRENT_BB_VERSION}\n${UPSTREAM_BB_VERSION}" | sort -V | tail -n1)

# Fail if newer version is not upstream version
if [[ "${NEWER_VERSION}" != "${UPSTREAM_BB_VERSION}" ]]; then
  echo "Upstream bigbang is older than current"
  exit 1
else
  echo "Upstream bigbang is newer than or same as current"
  exit 0
fi
