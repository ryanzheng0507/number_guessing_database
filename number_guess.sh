#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=number_guess --tuples-only -c"

# echo -e "\nEnter your username:"
# read NAME
# USER_ID=$($PSQL "SELECT user_id FROM users WHERE name = '$NAME'")

# if [[ -z $USER_ID ]]
# then
# echo -e "\nWelcome, $NAME! It looks like this is your first time here."
# fi

NUMBER_GUESSING() {
  echo -e "\nGuess the secret number between 1 and 1000:"
  read GUESS
  RANDOM_NUMBER=$(( ( $RANDOM % 1000) + 1 ))
  COUNT=1
  echo $RANDOM_NUMBER
  while [[ $GUESS != $RANDOM_NUMBER ]]
  do
  if [[ $GUESS > $RANDOM_NUMBER ]]
  then
  echo -e "\nIt's lower than that, guess again:"
  read GUESS
  COUNT=$(( $COUNT + 1 ))
  elif [[ $GUESS < $RANDOM_NUMBER ]]
  then
  echo -e "\nIt's higher than that, guess again:"
  read GUESS
  COUNT=$(( $COUNT + 1 ))
  fi
  done
  echo -e "\nYou guessed it in $COUNT tries. The secret number was $RANDOM_NUMBER. Nice job!"
}

NUMBER_GUESSING