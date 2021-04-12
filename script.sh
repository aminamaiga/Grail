#!/bin/bash
echo "RUN the 3 containers"
docker run -d -it --name container1 aminavero/pyth:first || docker start container1 
docker run -d -it --volumes-from container1 --name container2 efrecon/mini-tcl || docker start container2
docker run -d -it --volumes-from container1 --name container3 swipl || docker start container3

docker cp raw.txt container1:/app/GrailLight/raw.txt
 
RESULT=$?
if [ $RESULT -eq 0 ]; then
    printf 'Containers run succeeded\n'
else
    printf 'Error Running containers\n'
fi 

docker exec -it container2 sh -c '/app/GrailLight/tokenize.tcl  /app/GrailLight/raw.txt > /app/GrailLight/input.txt' 
RESULT2=$?
if [ $RESULT2 -eq 0 ]; then
    printf 'Tokenisation succeeded\n'
else
    printf 'Error Tokenisation\n'
fi 

docker exec -it container1 bash -c 'python3 elmo_superpos/super.py --input=../GrailLight/input.txt --output=/app/GrailLight/supertag.txt --beta=0.01'    
RESULT3=$?
if [ $RESULT3 -eq 0 ]; then
    printf 'Tagging succeeded\n'
else
    printf 'Error Tagging\n'
fi 

docker exec -it container2 sh -c 'tclsh /app/GrailLight/supertag2pl /app/GrailLight/supertag.txt > /app/GrailLight/superpos_nolem.pl'
RESULT4=$?
if [ $RESULT4 -eq 0 ]; then
    printf 'conversion in prolog succeeded\n'
else
    printf 'Error conversion in prolog succeeded\n'
fi 

docker exec -it container3 bash

# commande à saisr namuellement
#docker exec -it container3 bash -c ' swipl -s /app/GrailLight/lefff.pl -g "lemmatize(['./app/GrailLight/superpos_nolem.pl'])." -t halt. ' 
# swipl -s /app/GrailLight/grail_light_nd.pl -g "compile('./app/GrailLight/superpos')." -t halt.
# swipl -s /app/GrailLight/grail_light_nd.pl -g "chart_parse_all." -t halt.
# exit

#docker cp container1:/app/GrailLight/semantics.tex .
#docker cp container1:/app/GrailLight/semantics.tex .

#docker exec -it container1 bash -c 'pdflatex /app/GrailLight/semantics.tex' 
#docker cp container1:/app/GrailLight/semantics.pdf .
#exit
#docker exec -it container1 bash -c 'pdflatex /app/GrailLight/proof.tex'
#exit
#docker cp container1:/app/GrailLight/semantics.pdf .
#docker cp container1:/app/GrailLight/proof.pdf .







