#!/bin/bash

OCR_DATA="$1"

ocr_file () {
    target=$1
    original=/tmp/$(basename ${target})
    echo "${target} -> ${original}"
    cp -p ${target} ${original}
    
    base=$(basename ${original%.*})
    echo "convert -density 300 ${original} -depth 8 -contrast -colorspace gray -opaque none -alpha off -threshold 75% /tmp/${base}.tiff"
    convert -density 300 ${original} -depth 8 -contrast -colorspace gray -opaque none -alpha off -threshold 75% /tmp/${base}.tiff
    echo "tesseract /tmp/${base}.tiff /tmp/${base}.ocr -c tessedit_write_images=true -c textonly_pdf=1 -l deu+eng+fra pdf"
    tesseract /tmp/${base}.tiff /tmp/${base}.ocr -c tessedit_write_images=true -c textonly_pdf=1 -l deu+eng+fra pdf
    echo "pdftk ${original} background /tmp/${base}.ocr.pdf output ${target}"
    pdftk ${original} multibackground /tmp/${base}.ocr.pdf output ${target}
}

mkdir -p /tmp
if [[ -f "$OCR_DATA" ]]; then
    echo "[processing $OCR_DATA...]"
    ocr_file "$OCR_DATA"
else
    echo "[Starting tesseract-ocr service...]"
    inotifywait -e create --monitor --recursive --format '%w%f' "${OCR_DATA}" | while read -r target; do
        ocr_file "$target"
    done
fi

