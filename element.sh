#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

MAIN_MENU() {
  if [[ ! $1 ]]
  then
    echo "Please provide an element as an argument."
    exit 0
  fi
  MAIN_MENU_INPUT=$1
  
  if [[ $MAIN_MENU_INPUT =~ ^[0-9]$ ]]
  then
    CONDITION="atomic_number=$MAIN_MENU_INPUT"
  elif [[ $MAIN_MENU_INPUT =~ ^[A-Z]$|^[A-Z][a-z]$  ]]
  then
    CONDITION="symbol='$MAIN_MENU_INPUT'"
  else
    CONDITION="name='$MAIN_MENU_INPUT'"
  fi
  FOUND_ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING (atomic_number) JOIN types USING (type_id) WHERE $CONDITION")
  if [[ -z $FOUND_ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$FOUND_ELEMENT" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR TYPE BAR MASS BAR MELTING BAR BOILING
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  fi
}

MAIN_MENU $1
