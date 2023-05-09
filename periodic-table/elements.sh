#!/bin/bash
psql="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

print(){
  row=$($psql "select * from elements inner join properties using(atomic_number) inner join types using(type_id) where atomic_number=$atomic_number")
  echo "$row" | while IFS='|' read type_id atomic_number symbol name atomic_mass melting_point boiling_point type
  do
  echo -e "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
  done
}

if [[ $1 ]]
then
  if [[ $1 =~ ^[0-9]+ ]]
  then
    atomic_number=$($psql "select atomic_number from elements where atomic_number=$1")
    print
  elif [[ $1 =~ ^[A-Z][a-z]?$ ]]
  then
    atomic_number=$($psql "select atomic_number from elements where symbol='$1'")
    print
  elif [[ $1 =~ ^[A-Z][a-z]*$ ]]
  then
    atomic_number=$($psql "select atomic_number from elements where name='$1'")
    print
  else
    echo "I could not find that element in the database."
  fi
  else
  echo Please provide an element as an argument.
fi

