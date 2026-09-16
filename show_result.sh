#!/bin/bash

cat sentryssh.sh; cat lib/aggregate.sh lib/filter.sh lib/parse.sh lib/report.sh

echo -e "\n"

cat reports/sentryssh*
cat logs/sentryssh-run.log
cat config/sentryssh.conf

./sentryssh.sh --help
./sentryssh.sh
./sentryssh.sh --window 999999 --
./sentryssh.sh --output reports/custom-name.txt --window 999999 --threshold 5
./sentryssh.sh --nonsense