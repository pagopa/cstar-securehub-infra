#!/bin/bash
url=$1
curl -v -X PUT -H "Content-Type: application/json" --data @configs/kafka-connectors/transaction_in_progress_connector.json $url