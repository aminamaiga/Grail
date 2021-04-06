#!/bin/bash
echo "RUN the 3 containers"
docker run -d -it --name container1 aminavero/pyth:first || docker start container1 
docker run -d -it --volumes-from container1 --name container2 efrecon/mini-tcl || docker start container2
docker run -d -it --volumes-from container1 --name container3 swipl || docker start container3

 
RESULT=$?
if [ $RESULT -eq 0 ]; then
    printf 'Containers run succeeded\n'
else
    printf 'Erreur Running containers\n'
fi 

docker exec -it container2 sh -c '/app/GrailLight/tokenize.tcl  /app/GrailLight/raw.txt > /app/GrailLight/input.txt' 
RESULT2=$?
if [ $RESULT2 -eq 0 ]; then
    printf 'Tokenisation succeeded\n'
else
    printf 'Erreur Tokenisation\n'
fi 

docker exec -it container1 bash -c 'python3 elmo_superpos/super.py --input=../GrailLight/input.txt --output=supertag.txt --beta=0.01'    
docker exec -it container2 sh -c '/app/GrailLight/tokenize.tcl  /app/GrailLight/raw.txt > /app/GrailLight/input.txt' 
RESULT3=$?
if [ $RESULT3 -eq 0 ]; then
    printf 'Tagging succeeded\n'
else
    printf 'Erreur Tagging\n'
fi 

#docker exec -it container3 bash -c 'swipl -s /app/GrailLight/lefff.pl -t halt.'

docker exec -it container3 bash -c 'swipl -s /app/GrailLight/lefff.pl -g "lemmatize([superpos.txt])." -t halt.'
docker exec -it container3 bash -c 'swipl -s /app/GrailLight/lefff.pl -g "lemmatize([superpos_nolem.pl])." -t halt.'
docker exec -it container3 bash -c 'swipl -s /app/GrailLight/grail_light_nd.pl -g "lemmatize([superpos_nolem.pl])." -t halt.'
docker exec -it container3 bash -c 'swipl -s /app/GrailLight/superpos.pl -g "lemmatize([superpos.pl, superpos.pl])." -t halt.'
docker exec -it container3 bash -c 'swipl -s /app/GrailLight/grail_light_nd.pl -g "compile(superpos)." -t halt.'
docker exec -it container3 bash -c 'swipl -s /app/GrailLight/grail_light_nd.pl -g "chart_parse_all." -t halt.'

RESULT4=$?
if [ $RESULT4 -eq 0 ]; then
    printf 'Lemmatisation succeeded\n'
else
    printf 'Erreur Lemmatisation\n'
fi 