#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read year round winner opponent wg og
do
  if [[ $year != year ]]
  then
  # get name
  winner_n=$($PSQL "select name from teams where name='$winner'")
  opponent_n=$($PSQL "select name from teams where name='$opponent'")
  if [[ -z $winner_n ]]
  then
    insert_winner=$($PSQL "insert into teams(name) values('$winner')")
  fi
  if [[ -z $opponent_n ]]
  then
    insert_winner=$($PSQL "insert into teams(name) values('$opponent')")
  fi
  winner_id=$($PSQL "select team_id from teams where name='$winner'")
  opponent_id=$($PSQL "select team_id from teams where name='$opponent'")
  insert_games=$($PSQL " insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($year,'$round',$winner_id,$opponent_id,$wg,$og)")
  fi
done
