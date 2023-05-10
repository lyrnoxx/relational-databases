#!/bin/bash
psql="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

check_existing(){
    echo "Enter your username:"
    read username

    user_id=$($psql "select user_id from users where username='$username'")

    if [[ -z $user_id ]];
    then
        insert_user=$($psql "insert into users(username) values('$username')")
        echo "Welcome, $username! It looks like this is your first time here."
    else
        best_game=$($psql "select best_game from users where username='$username'")
        games_played=$($psql "select games_played from users where username='$username'")
        echo "Welcome back, $username! You have played $games_played games, and your best game took $best_game guesses."
    fi
}

get_guess(){
    echo "Guess the secret number between 1 and 1000:"
    while true; 
    do
        read guess
    
    if [[ ! $guess =~ ^[0-9]+$ ]]; 
    then
      echo "That is not an integer, guess again:"
    else
      check_guess
      break
    fi
  done
}

check_guess(){
    random=$(( RANDOM % 1000 + 1 ))
    num=1
    while true; 
    do
    if [[ $guess -lt $random ]];
    then
        echo "It's higher than that, guess again:"
        read guess
        (( num++ ))
    elif [[ $guess -gt $random ]];
    then
        echo "It's lower than that, guess again:"
        read guess
        (( num++ ))
    else 
        games_played=$((games_played + 1))
        insert_games=$($psql "update users set games_played=$games_played where username='$username'")
        echo "You guessed it in $num tries. The secret number was $random. Nice job!"
        if [[ $num -lt $best_game ]] || [[ -z $best_game ]];
        then
            insert_guesses=$($psql "update users set best_game=$num where username='$username'")
        fi
        break
    fi
    done
}

check_existing
get_guess
