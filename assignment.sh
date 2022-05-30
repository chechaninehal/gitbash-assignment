#!/bin/bash

output(){
    gpg --list-secret-keys --keyid-format=long
    echo "The respective keyID of the gpg keys with their indexes are - "
    key=$(gpg --list-secret-keys --keyid-format=long|awk '/sec/{if (length($2)>0) print $2}')
    declare -a keyArray

    n1=${#key}

    j=0
    keyIndex=0

    for((i=0;i<$n1;i++));
    do
    if [[ ${key:$i:1} == "/" ]]
        then
        keyArray[$j]=${key:$i+1:16}
        k=`expr $j + 1`
        echo Index = $k KeyId = ${keyArray[j]}
        ((j++))
        fi
    done

    echo "Type the Index of GPG key to be used"
    read keyIndex
    echo "Copy the following public key to paste on your GitHub's gpg key"
    gpg --armor --export ${keyArray[keyIndex - 1]}
}


echo "PRESS 1- To generate a new gpg key
PRESS 2- To use an already present gpg key"
read userinput

if [ $userinput -eq 1 ]
then 
gpg --full-generate-key
echo "gpg key has been generated"
output
fi

if [ $userinput -eq 2 ]
then 
        listgpgkey=$(gpg --list-secret-keys --keyid-format LONG)
        noofkeys=${#listgpgkey}

        if [ $noofkeys -gt 0 ]
        then
            echo "list of gpg keys:"
            # gpg --list-secret-keys --keyid-format LONG
        else 
            echo "No gpg key exists, To generate a new key: "
            gpg --full-generate-key
        fi    

        output
fi

else
echo "Choose either 1 or 2"
fi


