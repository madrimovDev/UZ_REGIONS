 
#!/bin/bash

# Asosiy sozlamalar
BASE_DIR="$(pwd)"
REGIONS_FILE="regions.json"
DETAILS_DIR="regions_details"
OUTPUT_FILE="all_regions_details.json"

# 1-qadam: Barcha regionlarni olish
echo "Barcha regionlarni olish..."
jq '.[]' "$REGIONS_FILE" | jq -s '.' > "$BASE_DIR/regions_all.json"

# 2-qadam: Har bir region uchun `region_id` qo'shib fayllarni birlashtirish
echo "Har bir region uchun `region_id` qo'shib fayllarni birlashtirish..."

mkdir -p temp_details
for file in "$DETAILS_DIR"/region_*.json; do
    region_id=$(basename "$file" | sed 's/region_\([0-9]*\)\.json/\1/')

    # Region faylidan `region_id` qo'shish
    jq --arg region_id "$region_id" '[.[] | . + {region_id: ($region_id | tonumber)}]' "$file" >> temp_details/temp_combined.json
done

# Barcha `temp_details` fayllarni birlashtirish
jq -s '[.[][]]' temp_details/temp_combined.json > "$OUTPUT_FILE"

# Tashqi fayllarni tozalash
rm -r temp_details

echo "Barcha fayllar muvaffaqiyatli birlashtirildi va $OUTPUT_FILE faylda saqlandi."
