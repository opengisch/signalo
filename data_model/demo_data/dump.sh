#!/usr/bin/env bash

pg_dump --data-only -t signalo_db.sign --column-inserts | gsort | gsed '/^INSERT/!d' > data_model/demo_data/sign_content.sql