#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
else
  # Check if $1 is a recognised atomic number
  SELECTED_ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where atomic_number = $1;")
  if [[ -z $SELECTED_ATOMIC_NUMBER ]]; then
    # If not, check if $1 is a recognised symbol
    SELECTED_ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where symbol like '$1';")
    if [[ -z $SELECTED_ATOMIC_NUMBER ]]; then
      # If not, check if $1 is a recognised element name
      SELECTED_ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where name like '$1';")
    fi
  fi
  # If still no match then display failure message
  if [[ -z $SELECTED_ATOMIC_NUMBER ]]; then
    echo "I could not find that element in the database."
  else
    # Get name from elements
    NAME=$($PSQL "select name from elements where atomic_number = $SELECTED_ATOMIC_NUMBER;")
    # Get symbol from elements
    SYMBOL=$($PSQL "select symbol from elements where atomic_number = $SELECTED_ATOMIC_NUMBER;")
    # Get type from properties join types
    TYPE=$($PSQL "select type from properties left join types using(type_id) where atomic_number = $SELECTED_ATOMIC_NUMBER;")
    # Get mass from properties
    MASS=$($PSQL "select atomic_mass from properties where atomic_number = $SELECTED_ATOMIC_NUMBER;")
    # Get melting point from properties
    MELTING=$($PSQL "select melting_point_celsius from properties where atomic_number = $SELECTED_ATOMIC_NUMBER;")
    # Get boiling point from properties
    BOILING=$($PSQL "select boiling_point_celsius from properties where atomic_number = $SELECTED_ATOMIC_NUMBER;")
    # Display information
    echo "The element with atomic number $SELECTED_ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  fi
fi