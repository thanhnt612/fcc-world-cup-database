#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games, teams")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
   #Get winnner team ================================================================
   if [[ $WINNER != winner ]]
   then
   TEAM_WINNER_NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
      #If not found
      if [[ -z $TEAM_WINNER_NAME ]]
      then
         #Insert team
         INSERT_TEAM_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
         if [[ $INSERT_TEAM_WIN_RESULT == "INSERT 0 1" ]]
         then
            echo Inserted team $WINNER
         fi
      fi
   fi

   #Get opponent team ================================================================
   if [[ $OPPONENT != opponent ]]
   then
   TEAM_OPPONENT_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
      #If not found
      if [[ -z $TEAM_OPPONENT_NAME ]]
      then
         #Insert team
         INSERT_TEAM_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
         if [[ $INSERT_TEAM_OPPONENT_RESULT == "INSERT 0 1" ]]
         then
            echo Inserted team $OPPONENT
         fi
      fi
   fi

   #Get the match ================================================================
   if [[ $YEAR != year ]]
   then
   WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
   OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
   #Insert match
   INSERT_MATCH_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
     if [[ $INSERT_MATCH_RESULT == "INSERT 0 1" ]]
     then
       echo Match: $YEAR, $ROUND, $WINNER_ID VS $OPPONENT_ID, score $WINNER_GOALS : $OPPONENT_GOALS
     fi
   fi
done