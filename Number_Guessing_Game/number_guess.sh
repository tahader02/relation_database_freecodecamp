#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=number_guess --tuples-only -c"

echo "Enter your username:"
read USERNAME

# get user_id
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

# if not found
if [[ -z $USER_ID ]] 
then 
  # insert username
  INSERT_USERNAME_RESULT=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")

  echo "Welcome, $USERNAME! It looks like this is your first time here."

  # get new user_id
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

  # update games played
  GAMES_PLAYED=$(($GAMES_PLAYED+1))
  UPDATE_GAMES_PLAYED=$($PSQL "UPDATE users SET games_played=$GAMES_PLAYED WHERE user_id=$USER_ID")
else 
  # get games played
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE user_id=$USER_ID")

  # get best NUMBER_OF_GUESSES
  BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE user_id=$USER_ID")

  echo "Welcome back, $USERNAME! You have played $(echo $GAMES_PLAYED | sed 's/ //') games, and your best game took $(echo $BEST_GAME | sed 's/ //') guesses."

  # update games played
  GAMES_PLAYED=$(($GAMES_PLAYED+1))
  UPDATE_GAMES_PLAYED=$($PSQL "UPDATE users SET games_played=$GAMES_PLAYED WHERE user_id=$USER_ID")
fi

# generate a random number
SECRET_NUMBER=$((1 + $RANDOM % 1000))
NUMBER_OF_GUESSES=0
GUESS=-1

echo -e "\nGuess the secret number between 1 and 1000:"


# if guess is wrong
while (($GUESS != $SECRET_NUMBER)) 
do
  # increment number of guesses
  let "NUMBER_OF_GUESSES+=1"
  read GUESS
  if [[ $GUESS =~ ^[0-9]+$ ]]
  then
    # if guess is higher
    if [[ $GUESS -lt $SECRET_NUMBER ]]
    then
      echo "It's higher than that, guess again:"
    # if guess is lower
    elif [[ $GUESS -gt $SECRET_NUMBER ]]
    then 
      echo "It's lower than that, guess again:"
    fi
  else 
    echo "That is not an integer, guess again:"
  fi
done

# if guess is right
if [[ $GUESS -eq $SECRET_NUMBER ]]
then
  # get best game
  BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE user_id=$USER_ID")

  # update best game
  if [[ $NUMBER_OF_GUESSES -lt $BEST_GAME ]]
  then
    UPDATE_BEST_GAME=$($PSQL "UPDATE users SET best_game=$NUMBER_OF_GUESSES WHERE user_id=$USER_ID")
  fi
fi

echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
