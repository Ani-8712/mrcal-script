dos2unix mrcal.sh
echo "

                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                .   
                  .                                                                                 
                                         .                                                          
                                                                                                    
               .                                                                                    
                                  .                              .                                  
                                                                                                 .  
                     @@@@@@@@@@@@@*. -%@@@@@@@@@@@@@@@@@@@@@@* +@@@@@@@@@@@@@@@@@@@@@@@.            
                     @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@. +@@@@@@@@@@@@@@@@@@@@@@.             
                     ----------@@@@@@@@@@--------------@@@@@@. +@@@@@%********@@@@@@%               
                        .######@@@@@@@@@@#######*-.   .@@@@@#  +@@@@@+      .@@@@@@+                
                        .@@@@@@@@@@@@@@@@@@@@@@@@@@*  %@@@@@@%%@@@@@@@.    .@@@@@@-                 
                        .++++++@@@@@@@@@@*+++++@@@@@= @@@@@@@@@@@@@@@@.   :@@@@@@.                  
                     ++++++++++@@@@@@@@@@++++++@@@@@+:@@@@@@@@@@@@@@@@.  +@@@@@@.                   
                     @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%.          +@@@@@+  %@@@@@#         .:          
   .                 @@@@@@@@@@@@@=. .%@@@@@@@@@@#.           .+@@@@@+ @@@@@@+          .%          
                                                                                        #%          
                                                                                      =@@:          
                                                                     .           ..*@@@@.           
                                                .=++++= +%#+: .:#@@@%%%####%%@@@@@@@@@@.            
                                            .-*.=*+===+ =*#%@@@@%-.-@@@@@@@@@@@@@@@@@-              
                      .       .      .:  -@*+*@@#-@@@@-#@@@@@#=+@@@@:.%@@@@@@@@@@@@+                
                                    *@@@*-+#+@@@@%%@@*:@@@@@@@@@%+%@@@.:@@@@@@@@@-                  
     .                           . #@@@+@@@@@@*#*#=*##**#*@@@@@@@@++@@@::@@@@@@:         .          
                              .*@: @@@=#@@@%***-%@@@@@@@@+%@@@@@@@@#@@@%.@@@#.                      
                            .#@@@= @@@-=*+#@@@@@+##@@@@@+=*#+=+**++=@@@*.@-                         
                          .#@@@@@@.%**#@@@@@@@@@@@#=@*@%@@*+*%@@@+#@@+@%.                           
                        .#@@@%###*%@@@@@@@@@#*+*#%@@@@#%@@@@@%=%=#@@*%@#                            
                        %*#@@@@@#*@@@@#*#+#@%+=+*#%@@@%=@+=+##*##@@@@%                              
                        @@@@@@@##@@**%@@@**#**@@@@@@@@@@++@@@@@@*@@@*                               
                        =@#-. .+%@@@@@@@@@@@%#**-@@@@@@@@=@@@@%+  ..                .               
                              #%%%@@@@@@@@@@@@@@+@@@@@@@@ -:                                        
                              #@@@@@@@@@@@@@@@@@+..:::::.                                  .        
                              .++=-::.....                                                          
                                                                                                    
                                                                                                    
                                                            .                                       
                                                                                               .    
                    .                   .                                                           
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    

"



SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
SCRIPTPATH=$(dirname "$SCRIPT")


# echo "scriptPath" $SCRIPTPATH
# echo "script" $SCRIPT 

echo "Welcome to the Mrcal Script. Before you proceed, please create a folder to store both the calibration video and the other files"


vidPath=''
echo "Enter the folder path (starting from /mnt/c) where you stored your video" 
read vidPath

cd $vidPath

vidName=''
echo "Enter the name of the video, inclduing extension"
read vidName

echo $PWD

echo "Is this the directory with your video? press enter to confirm:"
read 



echo "monkey"
echo $vidPath
echo $vidName



ffmpeg -i $vidName 'img%04d.png' 

echo "Done splitting video, starting corner detections"
       
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

JSON_NAME=''
echo "enter the name of the json file you want: "
read JSON_NAME


echo "python3 $SCRIPTPATH/gptCalibUtils.py "camera-0.cameramodel " $JSON_NAME.json"
read

echo $PWD
read

python3 $SCRIPTPATH/gptCalibUtils.py "$PWD/camera-0.cameramodel" $JSON_NAME.json

