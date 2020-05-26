#!/bin/bash

# Copyright 2020 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# NOTE: The Webhook App Deployment requires:
# 	- The project to exist before deployment
# 	- App Engine must be created but no service needs to be deployed

# Move to Root Directory
cd ../.. || exit

# Build Webhook Pipeline
make test_build

# Send Test Data
echo "Send Data: 1003 Records"
python3 tests/system/send_data.py

# Wait for Results to Load into BigQuery
# Then validate results
export _SLEEP_SECS=300
echo "Sleep for 300 seconds"
sleep 300
export RESULT_TABLE_COUNT=$(echo "SELECT COUNT(1) AS row_count FROM ${BQ_DATASET}.${BQ_TABLE_TEMPLATE};" | bq query | grep '|' | tail -n 1 | awk '{print $2;}')
echo "*** Table Row Count: Expected 1003 --> Found ${RESULT_TABLE_COUNT}"

# Destroy Deployment
make test_destroy
