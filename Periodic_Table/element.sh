#/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then 
  echo Please provide an element as an argument.
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")

    if [[ -z $ATOMIC_NUMBER ]]
    then
      echo "I could not find that element in the database."
    else
      # get element name
      ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")

      # get element symbol
      ELEMENT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")

      # get element type
      ELEMENT_TYPE=$($PSQL "SELECT type FROM types, properties WHERE types.type_id=properties.type_id AND properties.atomic_number=$ATOMIC_NUMBER") 

      # get element atomic_mass
      ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")

      # get melting point
      MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")

      # get boiling point
      BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")

      # print element info
      echo "The element with atomic number $(echo $ATOMIC_NUMBER | sed 's/ //') is $(echo $ELEMENT_NAME | sed 's/ //') ($(echo $ELEMENT_SYMBOL | sed 's/ //')). It's a $(echo $ELEMENT_TYPE | sed 's/ //'), with a mass of $(echo $ATOMIC_MASS | sed 's/ //') amu. $(echo $ELEMENT_NAME | sed 's/ //') has a melting point of $(echo $MELTING_POINT | sed 's/ //') celsius and a boiling point of $(echo $BOILING_POINT | sed 's/ //') celsius."

    fi
  
  else
    if [[ ${#1} -le 2 ]]
    then
      ELEMENT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1'")

      if [[ -z $ELEMENT_SYMBOL ]]
      then
        echo "I could not find that element in the database."
      else
        # get element name
        ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE symbol='$1'")

        # get element atomic number
        ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")

        # get element type
        ELEMENT_TYPE=$($PSQL "SELECT type FROM types, properties WHERE types.type_id=properties.type_id AND properties.atomic_number=$ATOMIC_NUMBER") 

        # get element atomic_mass
        ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")

        # get melting point
        MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")

        # get boiling point
        BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")

        # print element info
        echo "The element with atomic number $(echo $ATOMIC_NUMBER | sed 's/ //') is $(echo $ELEMENT_NAME | sed 's/ //') ($(echo $ELEMENT_SYMBOL | sed 's/ //')). It's a $(echo $ELEMENT_TYPE | sed 's/ //'), with a mass of $(echo $ATOMIC_MASS | sed 's/ //') amu. $(echo $ELEMENT_NAME | sed 's/ //') has a melting point of $(echo $MELTING_POINT | sed 's/ //') celsius and a boiling point of $(echo $BOILING_POINT | sed 's/ //') celsius."
      fi 
    else 
      ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE name='$1'")

      if [[ -z $ELEMENT_NAME ]]
      then
        echo "I could not find that element in the database."
      else
        # get element symbol
        ELEMENT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name='$1'")

        # get element atomic number
        ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1'")

        # get element type
        ELEMENT_TYPE=$($PSQL "SELECT type FROM types, properties WHERE types.type_id=properties.type_id AND properties.atomic_number=$ATOMIC_NUMBER") 

        # get element atomic_mass
        ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")

        # get melting point
        MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")

        # get boiling point
        BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")

        # print element info
        echo "The element with atomic number $(echo $ATOMIC_NUMBER | sed 's/ //') is $(echo $ELEMENT_NAME | sed 's/ //') ($(echo $ELEMENT_SYMBOL | sed 's/ //')). It's a $(echo $ELEMENT_TYPE | sed 's/ //'), with a mass of $(echo $ATOMIC_MASS | sed 's/ //') amu. $(echo $ELEMENT_NAME | sed 's/ //') has a melting point of $(echo $MELTING_POINT | sed 's/ //') celsius and a boiling point of $(echo $BOILING_POINT | sed 's/ //') celsius."
      fi
    fi
  fi
fi
