SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
SCRIPTPATH=$(dirname "$SCRIPT")

echo "scriptPath" $SCRIPTPATH
echo "script" $SCRIPT



vidPath=''
echo "Enter Video Path. Video must be the same resolution as your wanted resolution: " 
read vidPath

echo "$PWD/$vidPath"

echo "monkey"
echo $vidpath

ffmpeg -i $vidPath 'img%04d.png' 
       
mrgingham --jobs 4 --gridn 7 '*.png' > corners.vnl 

< corners.vnl       \
  vnl-filter -p x,y | \
  feedgnuplot --domain --square --set 'xrange [0:6000] noextend' --set 'yrange [3376:0] noextend'

mrcal-calibrate-cameras         \
  --corners-cache corners.vnl   \
  --lensmodel LENSMODEL_OPENCV8 \
  --focal 1900                  \
  --object-spacing 0.0588       \
  --object-width-n 7           \
  '*.png'

$CAMERAMODEL_NAME = "camera-0.cameramodel"
read -p "enter the name of the cameramodel file that was generated, INCLUDING the .cameramodel file type (empty for default name)" $CAMERAMODEL_NAME


read -p "enter the name of the json file you want: " $JSON_NAME





python3 $SCRIPTPATH/gptCalibUtils.py $CAMERAMODEL_NAME $JSON_NAME.json

