#!/bin/bash

cat sentryssh.sh; cat lib/aggregate.sh lib/filter.sh lib/parse.sh lib/report.sh

echo -e "\n"

cat reports/sentryssh*

./sentryssh.sh 999999 5