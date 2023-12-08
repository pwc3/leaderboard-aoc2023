#!/usr/bin/env bash

date=$(date +%Y-%m-%d)
swift run leaderboard fetch
swift run leaderboard csv
mv "leaderboard.csv" "leaderboard-${date}.csv"
echo "Wrote leaderboard-${date}.csv"

