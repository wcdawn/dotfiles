#!/bin/bash

COLOROPT="Lineart"
while getopts ":ch : option" opt
do
  case ${opt} in 
    c ) # color
      COLOROPT="Color"
      ;;
    h ) # help
      echo "Usage " $0 "[-ch] outname.pdf"
      echo "use the -c option for color"
      echo "use the -h option for help"
      exit 0
      ;;
    \? ) # error
      echo "Usage " $0 "[-ch] outname.pdf"
      echo "-h for help"
      exit 1
      ;;
  esac
done

shift $(( OPTIND - 1 ))

if [ -z $1 ]
then
  echo "no file name..."
  echo "an output file name is required..."
  exit 1
fi

BATCHFORMAT="./out%d.tiff"
BATCHSCREEN='./out*.tiff'

INTERMEDIATE_TIFF="./intermediate.tiff"
INTERMEDIATE_PDF="./intermediate.pdf"
FINAL_FILE=$1

# to list all scanners available
# $ scanimage -L
# to list options for a particular scanner
# $ scanimage --help --device="DEVICENAME"

DEVICE="epson2:net:192.168.1.12"
#Options specific to device `epson2:net:192.168.1.12':
#  Scan Mode:
#    --mode Lineart|Gray|Color [Lineart]
#        Selects the scan mode (e.g., lineart, monochrome, or color).
#    --depth 8bit [inactive]
#        Number of bits per sample, typical values are 1 for "line-art" and 8
#        for multibit scans.
#    --halftoning None|Halftone A (Hard Tone)|Halftone B (Soft Tone)|Halftone C (Net Screen)|Dither A (4x4 Bayer)|Dither B (4x4 Spiral)|Dither C (4x4 Net Screen)|Dither D (8x4 Net Screen)|Text Enhanced Technology|Download pattern A|Download pattern B [inactive]
#        Selects the halftone.
#    --dropout None|Red|Green|Blue [None]
#        Selects the dropout.
#    --brightness 0..0 [inactive]
#        Selects the brightness.
#    --sharpness -2..2 [inactive]
#        
#    --gamma-correction User defined (Gamma=1.0)|User defined (Gamma=1.8) [User defined (Gamma=1.8)]
#        Selects the gamma correction value from a list of pre-defined devices
#        or the user defined table, which can be downloaded to the scanner
#    --color-correction None|Built in CCT profile|User defined CCT profile [inactive]
#        Sets the color correction table for the selected output device.
#    --resolution 75|100|150|300|600|1200dpi [75]
#        Sets the resolution of the scanned image.
RESOLUTION="300"
#    --threshold 0..255 [128]
#        Select minimum-brightness to get a white point
WHITE_THRESHOLD="150"
#  Advanced:
#    --mirror[=(yes|no)] [inactive]
#        Mirror the image.
#    --auto-area-segmentation[=(yes|no)] [inactive]
#        Enables different dithering modes in image and text areas
#    --red-gamma-table 0..255,...
#        Gamma-correction table for the red band.
#    --green-gamma-table 0..255,...
#        Gamma-correction table for the green band.
#    --blue-gamma-table 0..255,...
#        Gamma-correction table for the blue band.
#    --wait-for-button[=(yes|no)] [no]
#        After sending the scan command, wait until the button on the scanner
#        is pressed to actually start the scan process.
#  Color correction:
#    --cct-type Automatic|Reflective|Colour negatives|Monochrome negatives|Colour positives [inactive]
#        Color correction profile type
#    --cct-profile -2..2,...
#        Color correction profile data
#  Preview:
#    --preview[=(yes|no)] [no]
#        Request a preview-quality scan.
#  Geometry:
#    -l 0..215.9mm [0]
#        Top-left x position of scan area.
#    -t 0..297.18mm [0]
#        Top-left y position of scan area.
#    -x 0..215.9mm [215.9]
#        Width of scan-area.
# corresponds to letter paper
WIDTH="215.9"
#    -y 0..297.18mm [297.18]
#        Height of scan-area.
# corresponds to letter paper
HEIGHT="279.4"
#  Optional equipment:
#    --source Flatbed|Automatic Document Feeder [Flatbed]
#        Selects the scan source (such as a document-feeder).
SOURCE='Automatic Document Feeder'
#SOURCE='Flatbed'
#    --auto-eject[=(yes|no)] [no]
#        Eject document after scanning
#    --film-type Positive Film|Negative Film|Positive Slide|Negative Slide [inactive]
#        
#    --focus-position Focus on glass|Focus 2.5mm above glass [inactive]
#        Sets the focus position to either the glass or 2.5mm above the glass
#    --bay 1|2|3|4|5|6 [inactive]
#        Select bay to scan
#    --eject []
#        Eject the sheet in the ADF
#    --adf-mode Simplex|Duplex [Simplex]
#        Selects the ADF mode (simplex/duplex)
ADFMODE="Simplex"

if [ $COLOROPT = "Color" ]
then
  # color sets to color and does not use threshold
  MYCOMMAND=$(printf "scanimage --device=%s --mode=%s --resolution=%s -x %s -y %s --source=\"%s\" --adf-mode=%s --batch=%s --format=tiff -v "  \
    $DEVICE $COLOROPT $RESOLUTION $WIDTH $HEIGHT "$SOURCE" $ADFMODE \
    $BATCHFORMAT)
else
  MYCOMMAND=$(printf "scanimage --device=%s --resolution=%s --threshold=%s -x %s -y %s --source=\"%s\" --adf-mode=%s --batch=%s --format=tiff -v "  \
    $DEVICE $RESOLUTION $WHITE_THRESHOLD $WIDTH $HEIGHT "$SOURCE" $ADFMODE \
    $BATCHFORMAT)
fi

# run scanimage
echo $MYCOMMAND
eval $MYCOMMAND

# merge tiff files
tiffcp $BATCHSCREEN $INTERMEDIATE_TIFF
# make a pdf
convert $INTERMEDIATE_TIFF $INTERMEDIATE_PDF

# shrink the pdf
tiff2pdf $INTERMEDIATE_TIFF -o $FINAL_FILE

# cleanup
rm $BATCHSCREEN $INTERMEDIATE_TIFF $INTERMEDIATE_PDF
