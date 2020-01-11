#!/bin/bash

PHOTOSHELTER_GALLERY_URL=https://thayerandco.photoshelter.com/gallery/19-23-Helix-Scribe/G0000wQIPYfxyTvA/C0000jZ6fg6TX6Oc
PHOTOSHELTER_GALLERY_HTML_PAGE=photoshelter_gallery.html
PHOTOSHELTER_IMAGE_URL_PREFIX=https://ssl.c.photoshelter.com/img-get2

PHOTOSHELTER_GALLERY_NAME=`echo ${PHOTOSHELTER_GALLERY_URL} | awk -F '/' '{print $5}'`

TEMP_PHOTO_URLS_FILE=photo-urls.txt

echo "PHOTOSHELTER_GALLERY_URL = ${PHOTOSHELTER_GALLERY_URL}"
echo "PHOTOSHELTER_GALLERY_HTML_PAGE = ${PHOTOSHELTER_GALLERY_HTML_PAGE}"
echo "PHOTOSHELTER_GALLERY_NAME = ${PHOTOSHELTER_GALLERY_NAME}"
echo "PHOTOSHELTER_IMAGE_URL_PREFIX = ${PHOTOSHELTER_IMAGE_URL_PREFIX}"

echo "TEMP_PHOTO_URLS_FILE = ${TEMP_PHOTO_URLS_FILE}"

echo "Downloading the html page"
#wget -O ${PHOTOSHELTER_GALLERY_HTML_PAGE} ${PHOTOSHELTER_GALLERY_URL}

echo "Grepping the photo urls with dimensions"
cat ${PHOTOSHELTER_GALLERY_HTML_PAGE} | \
    grep ${PHOTOSHELTER_IMAGE_URL_PREFIX} | \
    awk -F '\"' '{print $6 "=" $22 "x" $26}' | \
    awk -F '=' '{print $1 "=" $5}' > ${TEMP_PHOTO_URLS_FILE}

echo "Downloading all the files to ${PHOTOSHELTER_GALLERY_NAME}"
mkdir -p ${PHOTOSHELTER_GALLERY_NAME}
COUNTER=000
while read URL; do
  IMAGE_FILE_NAME='Image_'`printf "%03d.jpg" ${COUNTER}`
  echo "Downloading ${URL} to ${IMAGE_FILE_NAME}"
  wget -O ${PHOTOSHELTER_GALLERY_NAME}/${IMAGE_FILE_NAME} ${URL}
  # As a precaution, not to hit their rate limits for a single IP
  # sleep 1
  COUNTER=$((COUNTER+1))
done < ${TEMP_PHOTO_URLS_FILE}

echo "Cleaning up temporary files"
rm ${TEMP_PHOTO_URLS_FILE}

echo "Successfully downloaded all the files"
