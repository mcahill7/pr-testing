#!/bin/bash
curl "https://api.github.com/repos/$0/$1/statuses/$2?access_token=$3" \
  -H "Content-Type: application/json" \
  -X POST \
  -d "{\"context\": \"#Coverage Change\", \"state\": \"success\", \"description\": \"$4\"}"
