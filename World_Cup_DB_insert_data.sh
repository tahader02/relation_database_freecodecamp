#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year ]]
  then 
    # get winner_team_id
    WINNER_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

    # if not found
    if [[ -z $WINNER_TEAM_ID ]]
    then
      #insert WINNER TEAM
      INSERT_WINNER_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")

      if [[ $INSERT_WINNER_TEAM_RESULT = "INSERT 0 1" ]]
      then
        echo "Inserted into teams, $WINNER"
      fi

      # get new winner_team_id
      WINNER_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi

    # get opponent_team_id
    OPPONENT_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    # if not found
    if [[ -z $OPPONENT_TEAM_ID ]]
    then
      #insert OPPONENT TEAM
      INSERT_OPPONENT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")

      if [[ $INSERT_OPPONENT_TEAM_RESULT = "INSERT 0 1" ]]
      then 
        echo "Inserted into teams, $OPPONENT"
      fi

      # get new opponent_team_id
      OPPONENT_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi

    # get game_id
    GAME_ID=$($PSQL "SELECT game_id FROM games WHERE winner_id = $WINNER_TEAM_ID AND opponent_id = $OPPONENT_TEAM_ID")

    # if not found
    if [[ -z $GAME_ID ]]
    then
      # insert game 
      INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR, '$ROUND', (SELECT team_id FROM teams WHERE team_id=$WINNER_TEAM_ID), (SELECT team_id FROM teams WHERE team_id=$OPPONENT_TEAM_ID), $WINNER_GOALS, $OPPONENT_GOALS)")

      if [[ $INSERT_GAME_RESULT = " INSERT 0 1" ]]
      then 
        echo "Inserted into games, $WINNER - $OPPONENT , $ROUND $YEAR"
      fi
     
      # get new game_id
      GAME_ID=$($PSQL "SELECT game_id FROM games WHERE winner_id = $WINNER_TEAM_ID AND opponent_id = $OPPONENT_TEAM_ID")  
    fi
  fi
done






