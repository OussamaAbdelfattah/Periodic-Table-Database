#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

if [ $# -eq 0 ]
then
  echo Please provide an element as an argument.
  exit
fi

# Vérifier si l'argument est un nombre
if [[ $1 =~ ^[0-9]+$ ]]; then
    # get major_id
    ELEMENT_SELECTED=$1
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$ELEMENT_SELECTED")
else
    # Vérifier la taille de la chaîne
    length=${#1}
    if [ $length -le 2 ]; then
      ELEMENT_SELECTED=$1
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$ELEMENT_SELECTED'")
    else
      ELEMENT_SELECTED=$1
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$ELEMENT_SELECTED'")
    fi
fi
# if found
if [[ ! -z $ATOMIC_NUMBER ]]
then
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
  NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
  TYPE_ID=$($PSQL "SELECT p.type_id FROM elements e, properties p WHERE e.atomic_number=$ATOMIC_NUMBER AND e.atomic_number=p.atomic_number")
  ATOMIC_MASS=$($PSQL "SELECT p.atomic_mass FROM elements e, properties p WHERE e.atomic_number=$ATOMIC_NUMBER AND e.atomic_number=p.atomic_number")
  MELTING_POINT=$($PSQL "SELECT p.melting_point_celsius FROM elements e, properties p WHERE e.atomic_number=$ATOMIC_NUMBER AND e.atomic_number=p.atomic_number")
  BOILING_POINT=$($PSQL "SELECT p.boiling_point_celsius FROM elements e, properties p WHERE e.atomic_number=$ATOMIC_NUMBER AND e.atomic_number=p.atomic_number")
  TYPE_NAME=$($PSQL "SELECT t.type FROM elements e, properties p, types t WHERE e.atomic_number=$ATOMIC_NUMBER AND e.atomic_number=p.atomic_number AND p.type_id=t.type_id")

  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE_NAME, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
else
  echo I could not find that element in the database.
fi