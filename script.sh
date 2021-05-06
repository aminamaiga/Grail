#!/bin/bash
echo "RUN the 4 containers"
docker run -d -it --name container1 aminavero/pyth || docker start container1 
docker run -d -it --volumes-from container1 --name container2 efrecon/mini-tcl || docker start container2
docker run -d -it --volumes-from container1 --name container3 swipl || docker start container3
docker run -d -it --volumes-from container1 --name container4 fbenz/pdflatex || docker start container4

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

docker exec -it container1 bash -c 'python elmo_superpos/super.py --input=../input.txt --output=/app/superpos.txt --beta=0.01'    
RESULT3=$?
if [ $RESULT3 -eq 0 ]; then
    printf 'Tagging succeeded\n'
else
    printf 'Error Tagging\n'
fi 

docker exec -it container2 sh -c 'tclsh /app/supertag2pl /app/superpos.txt > /app/superpos_nolem.pl'
RESULT4=$?
if [ $RESULT4 -eq 0 ]; then
    printf 'conversion in prolog succeeded\n'
else
    printf 'Error conversion in prolog succeeded\n'
fi 

docker exec -it container3 bash








