#!/bin/bash

# Asosiy sozlamalar
BASE_DIR="$(pwd)"
DETAILS_DIR="districts_details"
OUTPUT_FILE="all_districts_details.json"

# 1-qadam: Har bir district uchun `district_id` qo'shib fayllarni birlashtirish
echo "Har bir district uchun `district_id` qo'shib fayllarni birlashtirish..."

mkdir -p temp_details
for file in "$DETAILS_DIR"/district_*.json; do
    district_id=$(basename "$file" | sed 's/district_\([0-9]*\)\.json/\1/')

    # District faylidan `district_id` qo'shish
    jq --arg district_id "$district_id" '[.[] | . + {district_id: ($district_id | tonumber)}]' "$file" >> temp_details/temp_combined.json
done

# Barcha `temp_details` fayllarni birlashtirish
jq -s '[.[][]]' temp_details/temp_combined.json > "$OUTPUT_FILE"

# Tashqi fayllarni tozalash
rm -r temp_details

echo "Barcha fayllar muvaffaqiyatli birlashtirildi va $OUTPUT_FILE faylda saqlandi."
