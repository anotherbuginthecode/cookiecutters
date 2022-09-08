#!/bin/bash

bold=$(tput bold)
info=$(tput setaf 2)
reset=$(tput sgr0)

filename=$(basename -- "{{ cookiecutter.handler_file }}")
extension="${filename##*.}"

if [ "$extension" == "py" ];
then
echo " ${info}INFO: ${reset}Creating the file code/{{cookiecutter.handler_file}}${reset}"
cat << EOF > code/{{cookiecutter.handler_file}}
import json

def lambda_handler(event, context):
    #TODO implement
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
EOF

echo " ${info}INFO: ${reset}Creating file code/requirements.txt${reset}"
touch "code/requirements.txt"
fi

echo ""
echo ""
echo "Enjoy your project and remember to ${bold}Praise the sun!${reset}"
cat << EndOfMessage
   &                                                                         ,  
    *&                                                                    &&.   
    .&&&&                                                              %&&&&&&  
     &&((##                     (                                    %###.      
        .####.,                   (                                ,#####       
          ////*//                   ((######                    **//,//         
            //*//*//                 ###(((##                 ////////          
             */**/**,,, .            (  ##,./               ,//*/////           
                . ,,/////// / .      ####(###(         ///////,,.//.            
                  ,/,*/*///////.    /(##(####(.    ////.,///,///.               
                    /,//*/*///////@./(((##((,##%  ////////**,//                 
                        ///,.,////.@@@@@@@@@@@@@///*,//////                     
                          ///,@@@@#@@@@(/@@@@&@@@@@@@/,//.                      
                           ,/*@@@@&//@@//@@//@@@@@@@,//                         
                            //#@@@@@/&&&&&#/@@@@@@@*/                           
                              .(@#@(/&&*#&&///(/@@@/                         
                               @@@@///(&&////@@@@@@                             
                              @@@@/#@@@(/@@@&//@@@@@                            
                              @@@@@@@@@@/(@@@@@@@@@@                            
                               @@@@@@@@@@@@@@@@@@@@(                            
                              .,....*.*(%@@@@@@@@@@                             
                              .,,,,,,. ....,,,,,,,,                             
                              @@@@@@%( ,,,,,.,@@@@@@                            
                             /@@@@@@@@@@@@@@/.,,,,.@@                           
EndOfMessage