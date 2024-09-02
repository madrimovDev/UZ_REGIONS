#!/bin/bash

# Asosiy sozlamalar
BASE_URL="https://pm.gov.uz:8020"
HEADERS="Origin: https://murojaat.gov.uz"
LANGUAGE_HEADER="Language: ru"

# 1-qadam: Regions ro'yxatini olish
echo "Regions ro'yxatini olish..."
curl -X GET "$BASE_URL//dictionary/regions" -H "$HEADERS" -H "$LANGUAGE_HEADER" -o regions.json

# 2-qadam: Regions ro'yxati bo'yicha har bir regionga so'rov yuborish
echo "Regions bo'yicha so'rovlar..."
mkdir -p regions_details
jq -c '.[]' regions.json | while read region; do
    region_id=$(echo $region | jq -r '.id')
    curl -X GET "$BASE_URL//dictionary/regions?parent_id=$region_id" -H "$HEADERS" -H "$LANGUAGE_HEADER" -o "regions_details/region_$region_id.json"
done

# 3-qadam: Districts ro'yxati bo'yicha so'rov yuborish
echo "Districts bo'yicha so'rovlar..."
mkdir -p districts_details
for region_file in regions_details/*.json; do
    jq -c '.[]' "$region_file" | while read district; do
        district_id=$(echo $district | jq -r '.id')
        curl -X GET "$BASE_URL//dictionary/mahalla?district_id=$district_id" -H "$HEADERS" -H "$LANGUAGE_HEADER" -o "districts_details/district_$district_id.json"
    done
done

echo "Barcha so'rovlar muvaffaqiyatli yakunlandi."
