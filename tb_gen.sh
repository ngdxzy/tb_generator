#!/bin/bash

NAME=$1

MODULE_NAME=$(echo $1 | sed 's/\..*$//g')
TB_NAME="tb_${MODULE_NAME}.v"

rm -f ${TB_NAME}

echo "module tb_${MODULE_NAME}();" >> ${TB_NAME} >> ${TB_NAME}
#INPUTS=$(cat ${NAME} | grep input | sed -n 's/input//g' | tr -cd "0-9a-zA-Z_")
cat $1 | grep input | sed 's/input/reg/g' | sed 's/,//g' | sed 's/^.*$/&;/g' >> ${TB_NAME}
cat $1 | grep output | sed 's/output.*reg/wire/g' | sed 's/output/wire/g' | sed 's/,//g' | sed 's/^.*$/&;/g' >> ${TB_NAME}

PORTS=(`cat $1 | grep -E 'input|output' | sed -e 's/^[ ]*$//g' -e 's/input//g' -e 's/output.*reg//g' -e 's/output//g' -e 's/\[.*\]//g' | tr ',' ' '`)



echo "    ${MODULE_NAME} ${MODULE_NAME}_inst(" >> ${TB_NAME}

N=${#PORTS[*]}
i=1
echo "        .${PORTS[0]}(${PORTS[0]})" >> ${TB_NAME}
while(( $i < $N ))
do
    echo "        ,.${PORTS[$i]}(${PORTS[$i]})" >> ${TB_NAME}
    let "i++"
done
echo "    );" >> ${TB_NAME}

echo "    always begin" >> ${TB_NAME}
echo "    " >> ${TB_NAME}
echo "    end" >> ${TB_NAME}

echo "    initial begin" >> ${TB_NAME}
IPORTS=(`cat $1 | grep input | sed -e 's/^[ ]*$//g' -e 's/input//g' -e 's/output.*reg//g' -e 's/output//g' -e 's/\[.*\]//g' | tr ',' ' '`)
i=0
N=${#IPORTS[*]}
while(( $i < $N ))
do
    echo "    ${IPORTS[$i]}='d0" >> ${TB_NAME}
    let "i++"
done


echo "    end" >> ${TB_NAME}
echo "endmodule" >> ${TB_NAME}



