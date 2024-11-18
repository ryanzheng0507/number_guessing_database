#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=number_guess --tuples-only -c"

NUMBER_GUESSING() {
  if [[ $1 ]]
  then
  echo -e "\n$1"
  fi

  read GUESS
  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
  NUMBER_GUESSING "That is not an integer, guess again:"
  fi

  while [[ $GUESS != $RANDOM_NUMBER ]]
  do
  if [[ $GUESS > $RANDOM_NUMBER ]]
  then
  echo -e "\nIt's lower than that, guess again:"
  read GUESS
  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
  NUMBER_GUESSING "That is not an integer, guess again:"
  fi
  COUNT=$(( $COUNT + 1 ))
  elif [[ $GUESS < $RANDOM_NUMBER ]]
  then
  echo -e "\nIt's higher than that, guess again:"
  read GUESS
  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
  NUMBER_GUESSING "That is not an integer, guess again:"
  fi
  COUNT=$(( $COUNT + 1 ))
  fi
  done
  echo -e "\nYou guessed it in $COUNT tries. The secret number was $RANDOM_NUMBER. Nice job!"
}

echo -e "\nEnter your username:"
read NAME
USER_ID=$($PSQL "SELECT user_id FROM users WHERE name = '$NAME'")
RANDOM_NUMBER=$(( ( $RANDOM % 1000) + 1 ))
COUNT=1

if [[ -z $USER_ID ]]
then
echo -e "\nWelcome, $NAME! It looks like this is your first time here."
echo -e "\nGuess the secret number between 1 and 1000:"
NUMBER_GUESSING
INSERT_INFO=$($PSQL "INSERT INTO users(name, best_game) VALUES('$NAME', $COUNT)")
else
GAME=$($PSQL "SELECT games_played FROM users WHERE name = '$NAME'")
BEST=$($PSQL "SELECT best_game FROM users WHERE name = '$NAME'")
echo -e "\nWelcome back, $NAME! You have played $GAME games, and your best game took $BEST guesses."
echo -e "\nGuess the secret number between 1 and 1000:"
NUMBER_GUESSING
GAME=$(( $GAME + 1 ))
if [[ $COUNT < $BEST ]]
then
UPDATE_INFO=$($PSQL "UPDATE users SET best_game = $COUNT, games_played = $GAME WHERE name = '$NAME'")
else
UPDATE_INFO=$($PSQL "UPDATE users SET games_played = $GAME WHERE name = '$NAME'")
fi
fi
