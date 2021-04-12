#!/bin/bash
echo "RUN the 3 containers"
docker run -d -it --name container1 aminavero/pyth:latest || docker start container1 
docker run -d -it --volumes-from container1 --name container2 efrecon/mini-tcl || docker start container2
docker run -d -it --volumes-from container1 --name container3 swipl || docker start container3

docker cp raw.txt container1:/app/raw.txt
 
RESULT=$?
if [ $RESULT -eq 0 ]; then
    printf 'Containers run succeeded\n'
else
    printf 'Error Running containers\n'
fi 

docker exec -it container2 sh -c '/app/tokenize.tcl  /app/raw.txt > /app/input.txt' 
RESULT2=$?
if [ $RESULT2 -eq 0 ]; then
    printf 'Tokenisation succeeded\n'
else
    printf 'Error Tokenisation\n'
fi 

docker exec -it container1 bash -c 'python3 elmo_superpos/super.py --input=../input.txt --output=/app/supertag.txt --beta=0.01'    
RESULT3=$?
if [ $RESULT3 -eq 0 ]; then
    printf 'Tagging succeeded\n'
else
    printf 'Error Tagging\n'
fi 

docker exec -it container2 sh -c 'tclsh /app/supertag2pl /app/supertag.txt > /app/superpos_nolem.pl'
RESULT4=$?
if [ $RESULT4 -eq 0 ]; then
    printf 'conversion in prolog succeeded\n'
else
    printf 'Error conversion in prolog succeeded\n'
fi 

docker exec -it container3 bash

#swipl -s /app/lefff.pl -g "lemmatize." -t halt. 

# commande à saisr namuellement


#docker cp container1:/app/semantics.tex .
#docker cp container1:/app/semantics.tex .

#docker exec -it container1 bash -c 'pdflatex /app/semantics.tex' 
#docker cp container1:/app/semantics.pdf .
#exit
#docker exec -it container1 bash -c 'pdflatex /app/proof.tex'
#exit
#docker cp container1:/app/semantics.pdf .
#docker cp container1:/app/proof.pdf .







